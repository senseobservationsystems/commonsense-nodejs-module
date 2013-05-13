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

  deleteSession: (data, next) ->
    return @_api 'post', 'logout', data, next

  # D A T A P R O C E S S O R S #
  dataProcessors: (data, next) ->
    return @_api 'get', 'dataprocessors', data, next

  dataProcessor: (id, data, next) ->
    return @_api 'get', 'dataprocessors/' + id, data, next

  createDataProcessor: (data, next) ->
    return @_api 'post', 'dataprocessors', data, next

  updateDataProcessor: (id, data, next) ->
    return @_api 'put', 'dataprocessors/' + id + '', data, next

  deleteDataProcessor: (id, data, next) ->
    return @_api 'delete', 'dataprocessors/' + id, data, next

  # D A T A  P R O C E S S O R S  &  F I L E S #
  dataProcessorsFiles: (data, next) ->
    return @_api 'get', 'dataprocessors/files'

  dataProcessorFile: (filename, data, next) ->
    return @_api 'get', 'dataprocessors/files/' + filename, data, next

  createDataProcessorsFile: (filename, data, next) ->
    return @_api 'post', 'dataprocessors/files/' + filename, data, next

  updateDataProcessorsFile: (filename, data, next) ->
    return @_api 'put', 'dataprocessors/files/' + filename, data, next

  deleteDataProcessorsFile: (filename, data, next) ->
    return @_api 'delete', 'dataprocessors/files/' + filename, data, next

  # D E V I C E S #
  devices: (data, next) ->
    return @_api 'get', 'devices', data, next

  device: (id, data, next) ->
   return @_api 'get', 'devices/' + id, data, next

  deviceSensors: (id, data, next) ->
    return @_api 'get', 'devices/' + id + '/sensors.json', data, next

  # E N V I R O N M E N T S #
  # TODO: implement subenvironments
  environments: (data, next) ->
    return @_api 'get', 'environments', data, next

  environment: (id, data, next) ->
    return @_api 'get', 'environments/' + id, data, next

  createEnvironment: (data, next) ->
    return @_api 'post', 'environments', data, next

  updateEnvironment: (id, data, next) ->
    return @_api 'put', 'environments/' + id, data, next

  deleteEnvironment: (id, data, next) ->
    return @_api 'delete', 'environments/' + id, data, next

  # E N V I R O N M E N T S  &  S E N S O R S #
  environmentSensors: (id, data, next) ->
    return @_api 'get', 'environments/' + id + '/sensors', data, next

  createEnvironmentSensor: (id, data, next) ->
    return @_api 'post', 'environments/' + id + '/sensors', data, next

  deleteEnvironmentSensor: (id, sensor, next) ->
    return @_api 'delete', 'environments/', + id + '/sensors/' + sensor, next

  # G R O U P S #
  allGroups: (data, next) ->
    return @_api 'get', 'groups/all', data, next

  groups: (data, next) ->
    return @_api 'get', 'groups', data, next

  group: (id, data, next) ->
    return @_api 'get', 'groups/' + id, data, next

  createGroup: (data, next) ->
    return @_api 'post', 'groups', data, next

  updateGroup: (id, data, next) ->
    return @_api 'put', 'groups/' + id, data, next

  deleteGroup: (id, data, next) ->
    return @_api 'delete', 'groups/' + id, data, next

  # G R O U P S  &  U S E R S #
  groupUsers: (id, data, next) ->
    return @_api 'get', 'groups/' + id + '/users', data, next

  groupUser: (id, user, next) ->
    return @_api 'get', 'groups/' + id + '/users/' + user, next

  createGroupUser: (id, data, next) ->
    return @_api 'post', 'groups/' + id + '/users', data, next

  updateGroupUser: (id, user, data, next) ->
    return @_api 'put', 'groups/' + id + '/users/' + user, data, next

  deleteGroupUser: (id, user, next) ->
    return @_api 'delete', 'groups/' + id + '/users/' + user, next

  # G R O U P S  &  S E N S O R S #
  groupSensors: (id, data, next) ->
    return @_api 'get', 'groups/' + id + '/sensors', data, next

  createGroupSensor: (id, data, next) ->
    return @_api 'post', 'groups/' + id + '/sensors', data, next

  deleteGroupSensor: (id, sensor, next) ->
    return @_api 'delete', 'groups/' + id + '/sensors/' + sensors, next

  # S E N S O R S #
  sensors: (data, next) ->
    return @_api 'get', 'sensors', data, next

  sensor: (id, data, next) ->
    return @_api 'get', 'sensors/' + id, data, next

  createSensor: (data, next) ->
    return @_api 'post', 'sensors', data, next

  updateSensor: (id, data, next) ->
    return @_api 'put', 'sensors/' + id, data, next

  deleteSensor: (id, data, next) ->
    return @_api 'delete', 'sensors/' + id, data, next

  sensorsFind: (namespace, data, next) ->
    return @_api 'post', 'sensors/find?namespace=' + namespace, data, next

  # S E N S O R S  &  D A T A #
  sensorData: (id, data, next) ->
    return @_api 'get', 'sensors/' + id + '/data', data, next

  createSensorData: (id, data, next) ->
    return @_api 'post', 'sensors/' + id + '/data', data, next

  createSensorsData: (data, next) ->
    return @_api 'post', 'sensors/data', data, next

  deleteSensorData: (id, data_id, data, next) ->
    return @_api 'delete', 'sensors/' + id + '/data/' + data_id, next


  # S E N S O R S  &  E N V I R O N M E N T S #
  sensorEnvironments: (id, data, next) ->
    return @_api 'get', 'sensors/' + id + '/environment', data, next


  # S E N S O R S  &  D E V I C E S #
  sensorDevice: (id, data, next) ->
    return @_api 'get', 'sensors/' + id + '/device', data, next

  createSensorDevice: (id, data, next) ->
    return @_api 'post', 'sensors/' + id + '/device', data, next

  deleteSensorDevice: (id, data, next) ->
    return @_api 'delete', 'sensors/' + id + '/device', data, next


  # S E N S O R S  &  S E R V I C E S #
  sensorsAvailableServices: (data, next) ->
    return @_api 'get', 'sensors/services/available', data, next

  sensorRunningServices: (id, data, next) ->
    return @_api 'get', 'sensors/' + id + '/services', data, next

  sensorAvailableServices: (id, data, next) ->
    return @_api 'get', 'sensors/' + id + '/services/available', data, next

  createSensorService: (id, data, next) ->
    return @_api 'post', 'sensors/' + id + '/services', data, next

  deleteSensorService: (id, service, next) ->
    return @_api 'delete', 'sensors/' + id + '/services/' + service, next

  sensorServiceMethods: (id, service, next) ->
    return @_api 'get', 'sensors/' + id + '/services/' + service + '/methods', data, next

  sensorServiceLearn: (id, service, data, next) ->
    return @_api 'post', 'sensors/' + id + '/services/' + service + '/manualLearn', data, next

  sensorServiceMethod: (id, service, method, next) ->
    return @_api 'get', 'sensors/' + id + '/services/' + service + '/' + method, next

  createSensorServiceMethod: (id, service, method, data, next) ->
    return @_api 'post', 'sensors/' + id + '/services/' + service + '/' + method, data, next


  # M E T A T A G S #
  sensorsMetatags: (data, next) ->
    return @_api 'get', 'sensors/metatags', data, next

  sensorMetatags: (id, data, next) ->
    return @_api 'get', 'sensors/' + id + '/metatags', data, next

  createSensorMetatags: (id, data, next) ->
    return @_api 'post', 'sensors/' + id + '/metatags', data, next

  updateSensorMetatags: (id, data, next) ->
    return @_api 'put', 'sensors/' + id + '/metatags', data, next

  deleteSensorMetaTags: (id, data, next) ->
    return @_api 'delete', 'sensors/' + id + '/metatags', data, next


  # U S E R S #
  currentUser: (data, next) ->
    return @_api 'get', 'users/current', data, next

  users: (data, next) ->
    return @_api 'get', 'users', data, next

  user: (id, data, next) ->
    return @_api 'get', 'users/' + id, data, next

  createUser: (data, next) ->
    return @_api 'post', 'users', data, next

  updateUser: (id, data, next) ->
    return @_api 'put', 'users/' + id, data, next

  deleteUser: (id, data, next) ->
    return @_api 'delete', 'users/' + id, data, next


if typeof module is 'undefined'
  window['Sense'] = Sense
else
  module.exports = exports = Sense