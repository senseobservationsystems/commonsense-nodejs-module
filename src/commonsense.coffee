class Sense

  constructor: (@session_id = '') ->
    @api_url = 'https://api.sense-os.nl'

# Build on prototype for speed and memory performance
Sense::=
  available_methods: ['GET', 'POST', 'DELETE', 'PUT']


  _getRequestObject: () ->
    if window? and window.XMLHttpRequest?
      return new window.XMLHttpRequest()

    if window? and window.ActiveXObject?
      try
        request = new ActiveXObject('Msxml2.XMLHTTP')
      catch e
        try
          request = new ActiveXObject('Microsoft.XMLHTTP')
        catch e

    XMLHttpRequest = require('xmlhttprequest').XMLHttpRequest
    return new XMLHttpRequest()


  _api: (method, path, data, next) ->

    # create empty data object of none provided
    if typeof(data) isnt 'object'
      next = data
      data = {}
    data ?= ''

    # Create empty callback function if none proviced
    if not next? then next = ->

    # Check for supported HTTP method
    method = method.toUpperCase()
    unless method in @available_methods
      throw new Error "1: Method " + method + " not available"

    # Prefix the path with /
    path = '/' + path unless path[0] is '/'

    headers = ACCEPT: '*'
    headers['X-SESSION_ID'] = @session_id if @session_id isnt ''

    xhr = @._getRequestObject()
    xhr.onreadystatechange = =>

      if xhr.readyState == 4
        res =
          status: xhr.status
          data:   xhr.responseText
          object: {}

        location      = xhr.getResponseHeader 'Location'
        sid           = xhr.getResponseHeader 'X-SESSION_ID'
        @session_id   = sid if sid?
        res.location  = location? if location?

        if res.status in [200, 201, 302]
          if res.data.trim() isnt ''
            res.object = JSON.parse res.data

          next null, res
        else
          next (new Error "2: API returned non-succesful header."), res

    switch method

      when 'GET' or 'DELETE'
        str = []
        str.push(encodeURIComponent(key) + "=" + encodeURIComponent(value)) for key, value of data
        path += '?' + str.join('&')

      when 'POST' or 'PUT'
        if typeof(data) is "object"
          headers['Content-Type'] = 'application/json'
          data = JSON.stringify data
        else
          headers['Content-Type'] = 'text/plain' if typeof(data) is "string"
      else
        throw new Error "Unrecognized method"


    xhr.open method, (@api_url + path), true
    xhr.setRequestHeader(name, value) for name, value of headers
    xhr.send data

    # Return request object, so client code can overwrite events
    return xhr


  # CONFIGURATION #
  setServer: (s = 'live') ->
    @api_url = switch s
      when 'live' then 'https://api.sense-os.nl'
      when 'dev'  then 'http://api.dev.sense-os.nl'
      else throw new Error 'Unrecognized server'

  getServer: ->
    return @api_url

  #
  # A P I C A L L S
  #

  # A U T H E N T I C A T I O N #
  createSession: (u, p, next) ->
    return @_api 'post', 'login', username: u, password: p, next

  deleteSession: (next) ->
    return @_api 'post', 'logout', next

  # D A T A P R O C E S S O R S #
  dataProcessors: (next) ->
    return @_api 'get', 'dataprocessors', next

  dataProcessor: (id, next) ->
    return @_api 'get', 'dataprocessors/' + id, next

  createDataProcessor: (data, next) ->
    return @_api 'post', 'dataprocessors', data, next

  updateDataProcessor: (id, data, next) ->
    return @_api 'put', 'dataprocessors/' + id + '', data, next

  deleteDataProcessor: (id, next) ->
    return @_api 'delete', 'dataprocessors/' + id, next

  # D A T A  P R O C E S S O R S  &  F I L E S #
  dataProcessorsFiles: (next) ->
    return @_api 'get', 'dataprocessors/files'

  dataProcessorFile: (filename, next) ->
    return @_api 'get', 'dataprocessors/files/' + filename, next

  createDataProcessorsFile: (filename, data, next) ->
    return @_api 'post', 'dataprocessors/files/' + filename, data, next

  updateDataProcessorsFile: (filename, data, next) ->
    return @_api 'put', 'dataprocessors/files/' + filename, data, next

  deleteDataProcessorsFile: (filename, next) ->
    return @_api 'delete', 'dataprocessors/files/' + filename, next

  # D E V I C E S #
  devices: (next) ->
    return @_api 'get', 'devices', next

  device: (id, next) ->
   return @_api 'get', 'devices/' + id, next

  deviceSensors: (id, next) ->
    return @_api 'get', 'devices/' + id + '/sensors.json', next

  # E N V I R O N M E N T S #
  # TODO: implement subenvironments
  environments: (next) ->
    return @_api 'get', 'environments', next

  environment: (id, next) ->
    return @_api 'get', 'environments/' + id, next

  createEnvironment: (data, next) ->
    return @_api 'post', 'environments', data, next

  updateEnvironment: (id, data, next) ->
    return @_api 'put', 'environments/' + id, next

  deleteEnvironment: (id, next) ->
    return @_api 'delete', 'environments/' + id, next

  # E N V I R O N M E N T S  &  S E N S O R S #
  environmentSensors: (id, next) ->
    return @_api 'get', 'environments/' + id + '/sensors', next

  createEnvironmentSensor: (id, data, next) ->
    return @_api 'post', 'environments/' + id + '/sensors', data next

  deleteEnvironmentSensor: (id, sensor, next) ->
    return @_api 'delete', 'environments/', + id + '/sensors/' + sensor, next

  # G R O U P S #
  allGroups: (next) ->
    return @_api 'get', 'groups/all', next

  groups: (next) ->
    return @_api 'get', 'groups', next

  group: (id, next) ->
    return @_api 'get', 'groups/' + id, next

  createGroup: (data, next) ->
    return @_api 'post', 'groups', data, next

  updateGroup: (id, data, next) ->
    return @_api 'put', 'groups/' + id, data, next

  deleteGroup: (id, next) ->
    return @_api 'delete', 'groups/' + id, next

  # G R O U P S  &  U S E R S #
  groupUsers: (id, next) ->
    return @_api 'get', 'groups/' + id + '/users', next

  groupUser: (id, user, next) ->
    return @_api 'get', 'groups/' + id + '/users/' + user, next

  createGroupUser: (id, data, next) ->
    return @_api 'post', 'groups/' + id + '/users', data, next

  updateGroupUser: (id, user, data, next) ->
    return @_api 'put', 'groups/' + id + '/users/' + user, data, next

  deleteGroupUser: (id, user, next) ->
    return @_api 'delete', 'groups/' + id + '/users/' + user, next

  # G R O U P S  &  S E N S O R S #
  groupSensors: (id, next) ->
    return @_api 'get', 'groups/' + id + '/sensors', next

  createGroupSensor: (id, data, next) ->
    return @_api 'post', 'groups/' + id + '/sensors', data, next

  deleteGroupSensor: (id, sensor, next) ->
    return @_api 'delete', 'groups/' + id + '/sensors/' + sensors, next

  # S E N S O R S #
  sensors: (next) ->
    return @_api "get", "sensors", next

  sensor: (id, next) ->
    return @_api "get", "sensors/" + id, next

  createSensor: (data, next) ->
    return @_api "post", "sensors", data, next

  updateSensor: (id, data, next) ->
    return @_api "put", "sensors/" + id, data, next

  deleteSensor: (id, next) ->
    return @_api "delete", "sensors/" + id, next

  sensorsFind: (namespace, data, next) ->
    return @_api "post", "sensors/find?namespace=" + namespace, data, next

  # S E N S O R S  &  D A T A #
  sensorData: (id, next) ->
    return @_api "get", "sensors/" + id + "/data", next

  createSensorData: (id, data, next) ->
    return @_api "post", "sensors/" + id + "/data", data, next

  createSensorsData: (data, next) ->
    return @_api "post", "sensors/data", data, next

  deleteSensorData: (id, data_id, next) ->
    return @_api "delete", "sensors/" + id + "/data/" + data_id , next


  # S E N S O R S  &  E N V I R O N M E N T S #
  sensorEnvironments: (id, next) ->
    return @_api "get", "sensors/" + id + "/environment", next


  # S E N S O R S  &  D E V I C E S #
  sensorDevice: (id, next) ->
    return @_api "get", "sensors/" + id + "/device", next

  createSensorDevice: (id, data, next) ->
    return @_api "post", "sensors/" + id + "/device", data, next

  deleteSensorDevice: (id, next) ->
    return @_api "delete", "sensors/" + id + "/device", next


  # S E N S O R S  &  S E R V I C E S #
  sensorsAvailableServices: (next) ->
    return @_api "get", "sensors/services/available", next

  sensorRunningServices: (id, next) ->
    return @_api "get", "sensors/" + id + "/services", next

  sensorAvailableServices: (id, next) ->
    return @_api "get", "sensors/" + id + "/services/available", next

  createSensorService: (id, data, next) ->
    return @_api "post", "sensors/" + id + "/services", data, next

  deleteSensorService: (id, service, next) ->
    return @_api "delete", "sensors/" + id + "/services/" + service , next

  sensorServiceMethods: (id, service, next) ->
    return @_api "get", "sensors/" + id + "/services/" + service + "/methods", next

  sensorServiceLearn: (id, service, data, next) ->
    return @_api "post", "sensors/" + id + "/services/" + service + "/manualLearn", data, next

  sensorServiceMethod: (id, service, method, next) ->
    return @_api "get", "sensors/" + id + "/services/" + service + "/" + method , next

  createSensorServiceMethod: (id, service, method, data, next) ->
    return @_api "post", "sensors/" + id + "/services/" + service + "/" + method , data, next


  # M E T A T A G S #
  sensorsMetatags: (next) ->
    return @_api "get", "sensors/metatags", next

  sensorMetatags: (id, next) ->
    return @_api "get", "sensors/" + id + "/metatags", next

  createSensorMetatags: (id, data, next) ->
    return @_api "post", "sensors/" + id + "/metatags", data, next

  updateSensorMetatags: (id, data, next) ->
    return @_api "put", "sensors/" + id + "/metatags", data, next

  deleteSensorMetaTags: (id, next) ->
    return @_api "delete", "sensors/" + id + "/metatags", next


  # U S E R S #
  currentUsers: (next) ->
    return @_api "get", "users/current", next

  users: (next) ->
    return @_api "get", "users", next

  user: (id, next) ->
    return @_api "get", "users/" + id, next

  createUser: (next) ->
    return @_api "post", "users", next

  updateUser: (id, data, next) ->
    return @_api "put", "users/" + id, data, next

  deleteUser: (id, next) ->
    return @_api "delete", "users/" + id , next

module.exports = exports = Sense