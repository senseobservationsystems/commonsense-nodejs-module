http  = require 'http'
https = require 'https'
qs    = require 'querystring'
url   = require 'url'

class Sense

  constructor: (@session_id = '') ->
    @api_url = 'https://api.sense-os.nl'

# Build on prototype for speed and memory performance
Sense::=
  available_methods: ['GET', 'POST', 'DELETE', 'PUT']
  _api: (method, path, data, next) ->

    # create empty data object of none provided
    if typeof(data) isnt 'object'
      next = data
      data = {}

    # Create empty callback function if none proviced
    if not next? then next = ->


    # Check for supported HTTP method
    method = method.toUpperCase()
    unless method in @available_methods
      throw new Error "1: Method " + method + " not available"

    # Prefix the path with /
    path = '/' + path unless path[0] is '/'

    headers = ACCEPT: 'application/json'
    headers['X-SESSION_ID'] = @session_id if @session_id?

    data ?= ''
    switch method

      when 'GET' or 'DELETE'
        path += qs.stringify data
        data = ''

      when 'POST' or 'PUT'
        if typeof(data) is "object"
          headers['Content-Type'] = 'application/json'
          data = JSON.stringify data
        else
          headers['Content-Type'] = 'text/plain' if typeof(data) is "string"
      else
        throw new Error "Unrecognized method"

    parsed_url = url.parse(@api_url + path)
    options =
      host: parsed_url.host
      path: path
      method: method
      headers: headers

    # Switch protocol implementation
    protocol = if parsed_url.protocol is 'https' then https else http

    # Notice the fat arrow. This is to keep @ pointing to the Sense object
    request = protocol.request options, (response) =>

      # Build the object to be passed to the callback next function
      resp =
        status:   response.statusCode
        data:     ""
        headers:  response.headers

      # Retrieve session id and location headers
      sid           = response.headers['x-session_id']
      location      = response.headers.location
      @session_id   = sid if sid?
      resp.location = location if location?

      response.on 'error', (e)    -> next e, resp
      response.on 'data', (chunk) -> resp.data += chunk
      response.on 'end',          ->

        # Resonse is ended, all data received
        if resp.status in [200, 201, 302]
          if resp.data.trim() isnt ''
            resp.object = JSON.parse resp.data
          else
            resp.object = {}

          next null, resp
        else
          next (new Error "2: API returned non-succesful header."), resp

    request.on 'error', (e) -> next
    request.write data
    request.end()

    # Return request object, so client code can overwrite events
    return request


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
  createSession: (u, p, args...) ->
    return @_api 'post', 'login', username: u, password: p, args...

  deleteSession: (args...) ->
    return @_api 'post', 'logout', args...

  # D A T A P R O C E S S O R S #
  dataProcessors: (args...) ->
    return @_api 'get', 'dataprocessors', args...

  dataProcessor: (id, args...) ->
    return @_api 'get', 'dataprocessors/' + id, args...

  createDataProcessor: (data, args...) ->
    return @_api 'post', 'dataprocessors', data, args...

  updateDataProcessor: (id, data, args...) ->
    return @_api 'put', 'dataprocessors/' + id + '', data, args...

  deleteDataProcessor: (id, args...) ->
    return @_api 'delete', 'dataprocessors/' + id, args...

  # D A T A  P R O C E S S O R S  &  F I L E S #
  dataProcessorsFiles: (args...) ->
    return @_api 'get', 'dataprocessors/files'

  dataProcessorFile: (filename, args...) ->
    return @_api 'get', 'dataprocessors/files/' + filename, args...

  createDataProcessorsFile: (filename, data, args...) ->
    return @_api 'post', 'dataprocessors/files/' + filename, data, args...

  updateDataProcessorsFile: (filename, data, args...) ->
    return @_api 'put', 'dataprocessors/files/' + filename, data, args...

  deleteDataProcessorsFile: (filename, args...) ->
    return @_api 'delete', 'dataprocessors/files/' + filename, args...

  # D E V I C E S #
  devices: (args...) ->
    return @_api 'get', 'devices', args...

  device: (id, args...) ->
   return @_api 'get', 'devices/' + id, args...

  deviceSensors: (id, args...) ->
    return @_api 'get', 'devices/' + id + '/sensors.json', args...

  # E N V I R O N M E N T S #
  # TODO: implement subenvironments
  environments: (args...) ->
    return @_api 'get', 'environments', args...

  environment: (id, args...) ->
    return @_api 'get', 'environments/' + id, args...

  createEnvironment: (data, args...) ->
    return @_api 'post', 'environments', data, args...

  updateEnvironment: (id, data, args...) ->
    return @_api 'put', 'environments/' + id, args...

  deleteEnvironment: (id, args...) ->
    return @_api 'delete', 'environments/' + id, args...

  # E N V I R O N M E N T S  &  S E N S O R S #
  environmentSensors: (id, args...) ->
    return @_api 'get', 'environments/' + id + '/sensors', args...

  createEnvironmentSensor: (id, data, args...) ->
    return @_api 'post', 'environments/' + id + '/sensors', data args...

  deleteEnvironmentSensor: (id, sensor, args... ) ->
    return @_api 'delete', 'environments/', + id + '/sensors/' + sensor, args...

  # G R O U P S #
  allGroups: (args...) ->
    return @_api 'get', 'groups/all', args...

  groups: (args...) ->
    return @_api 'get', 'groups', args...

  group: (id, args...) ->
    return @_api 'get', 'groups/' + id, args...

  createGroup: (data, args...) ->
    return @_api 'post', 'groups', data, args...

  updateGroup: (id, data, args...) ->
    return @_api 'put', 'groups/' + id, data, args...

  deleteGroup: (id, args...) ->
    return @_api 'delete', 'groups/' + id, args...

  # G R O U P S  &  U S E R S #
  groupUsers: (id, args...) ->
    return @_api 'get', 'groups/' + id + '/users', args...

  groupUser: (id, user, args...) ->
    return @_api 'get', 'groups/' + id + '/users/' + user, args...

  createGroupUser: (id, data, args...) ->
    return @_api 'post', 'groups/' + id + '/users', data, args...

  updateGroupUser: (id, user, data, args...) ->
    return @_api 'put', 'groups/' + id + '/users/' + user, data, args...

  deleteGroupUser: (id, user, args...) ->
    return @_api 'delete', 'groups/' + id + '/users/' + user, args...

  # G R O U P S  &  S E N S O R S #
  groupSensors: (id, args...) ->
    return @_api 'get', 'groups/' + id + '/sensors', args...

  createGroupSensor: (id, data, args... ) ->
    return @_api 'post', 'groups/' + id + '/sensors', data, args...

  deleteGroupSensor: (id, sensor, args... ) ->
    return @_api 'delete', 'groups/' + id + '/sensors/' + sensors, args...

  # S E N S O R S #
  sensors: (args...) ->
    return @_api "get", "sensors", args...

  sensor: (id, args...) ->
    return @_api "get", "sensors/" + id, args...

  createSensor: (data, args...) ->
    return @_api "post", "sensors", data, args...

  updateSensor: (id, data, args...) ->
    return @_api "put", "sensors/" + id, data, args...

  deleteSensor: (id, args...) ->
    return @_api "delete", "sensors/" + id, args...

  sensorsFind: (namespace, data, args...) ->
    return @_api "post", "sensors/find?namespace=" + namespace, data, args...

  #/ S E N S O R S  &  D A T A #/
  sensorData: (id, args...) ->
    return @_api "get", "sensors/" + id + "/data", args...

  createSensorData: (id, data, args...) ->
    return @_api "post", "sensors/" + id + "/data", data, args...

  createSensorsData: (data, args...) ->
    return @_api "post", "sensors/data", data, args...

  deleteSensorData: (id, data_id, args...) ->
    return @_api "delete", "sensors/" + id + "/data/" + data_id , args...


  #/ S E N S O R S  &  E N V I R O N M E N T S #/
  sensorEnvironments: (id, args...) ->
    return @_api "get", "sensors/" + id + "/environment", args...


  #/ S E N S O R S  &  D E V I C E S #/
  sensorDevice: (id, args...) ->
    return @_api "get", "sensors/" + id + "/device", args...

  createSensorDevice: (id, data, args...) ->
    return @_api "post", "sensors/" + id + "/device", data, args...

  deleteSensorDevice: (id, args...) ->
    return @_api "delete", "sensors/" + id + "/device", args...


  #/ S E N S O R S  &  S E R V I C E S #/
  sensorsAvailableServices: (args...) ->
    return @_api "get", "sensors/services/available", args...

  sensorRunningServices: (id, args...) ->
    return @_api "get", "sensors/" + id + "/services", args...

  sensorAvailableServices: (id, args...) ->
    return @_api "get", "sensors/" + id + "/services/available", args...

  createSensorService: (id, data, args...) ->
    return @_api "post", "sensors/" + id + "/services", data, args...

  deleteSensorService: (id, service, args...) ->
    return @_api "delete", "sensors/" + id + "/services/" + service , args...

  sensorServiceMethods: (id, service, args...) ->
    return @_api "get", "sensors/" + id + "/services/" + service + "/methods", args...

  sensorServiceLearn: (id, service, data, args...) ->
    return @_api "post", "sensors/" + id + "/services/" + service + "/manualLearn", data, args...

  sensorServiceMethod: (id, service, method, args...) ->
    return @_api "get", "sensors/" + id + "/services/" + service + "/" + method , args...

  createSensorServiceMethod: (id, service, method, data, args...) ->
    return @_api "post", "sensors/" + id + "/services/" + service + "/" + method , data, args...


  #/ M E T A T A G S #/
  sensorsMetatags: (args...) ->
    return @_api "get", "sensors/metatags", args...

  sensorMetatags: (id, args...) ->
    return @_api "get", "sensors/" + id + "/metatags", args...

  createSensorMetatags: (id, data, args...) ->
    return @_api "post", "sensors/" + id + "/metatags", data, args...

  updateSensorMetatags: (id, data, args...) ->
    return @_api "put", "sensors/" + id + "/metatags", data, args...

  deleteSensorMetaTags: (id, args...) ->
    return @_api "delete", "sensors/" + id + "/metatags", args...


  #/ U S E R S #/
  currentUsers: (args...) ->
    return @_api "get", "users/current", args...

  users: (args...) ->
    return @_api "get", "users", args...

  user: (id, args...) ->
    return @_api "get", "users/" + id, args...

  createUser: (args...) ->
    return @_api "post", "users", args...

  updateUser: (id, data, args...) ->
    return @_api "put", "users/" + id, data, args...

  deleteUser: (id, args...) ->
    return @_api "delete", "users/" + id , args...

module.exports = exports = Sense