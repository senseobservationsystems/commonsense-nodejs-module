fs = require 'fs'
Sense = require __dirname + '/../src/commonsense'

# Provide your username and md5 password hash
username = ''
password_md5 = ''

# No changes needed below this file

String::capitalize = -> @substr(0, 1).toUpperCase() + @substr(1)

# Mock the API function of Sense
# It returns the parameters as constructed by the api-calling function
# So no real HTTP calls are performed
Sense::_api = (method, path, data, next) ->
  return {method: method, path: path, data: data}

sense = new Sense()

# Generic REST/HTTP actions. No nested urls implemented yet
GenericActions = (resource, actions = ['index', 'get', 'create', 'update', 'delete']) ->
  for index, action of actions

    describe "action #{action}", ->

      it "should create a good URL and HTTP method", (done) ->

        switch action
          when 'index'
            caller = resource + 's'
            path = "#{resource}s"
            method = 'get'
          when 'get'
            caller = resource
            id = 1
            path = "#{resource}s/#{id}"
            method = 'get'
          when 'create'
            caller = 'create' + resource.capitalize()
            path = "#{resource}s"
            method = 'post'
          when 'update'
            caller = 'update' + resource.capitalize()
            id = 1
            path = "#{resource}s/#{id}"
            method = 'put'
          when 'delete'
            caller = 'delete' + resource.capitalize()
            id = 1
            path = "#{resource}s/#{id}"
            method = 'delete'
          else
            throw new Error("Unknown action")

        function_ref = sense[caller]

        response = if id? then function_ref.call(sense, id) else function_ref.call(sense)

        response.path.toLowerCase().should.equal path.toLowerCase()
        response.method.should.equal method
        done()


console.log "TESTING"

describe 'Sense API calls', ->

  describe 'to Sessions', ->
    it "should handle custom paths for create and delete"

  describe 'to DataProcessors', ->
    GenericActions 'dataProcessor'

  describe 'to DataProcessorFile', ->
    it "should handle nested url"

  describe 'to Devices', ->
    GenericActions 'device', ['index', 'get']
    it "should "

  describe 'to Environments', ->
    GenericActions 'environment'

  describe 'to EnvironmentSensor', ->
    it "should handle nested url"

  describe 'to Groups', ->
    GenericActions 'group'
    it "should handle call allGroups"

  describe 'to Group and users', ->
    it "should handle nested url"

  describe 'to Group and sensors', ->
    it "should handle nested url"

  describe 'to Sensors', ->
    GenericActions 'sensor'

  describe 'to Sensors and data', ->
    it "should handle nested url"

  describe 'to Sensors and Environments', ->
    it "should handle nested url"

  describe 'to Sensors and devices', ->
    it "should handle nested url"

  describe 'to Sensors and services', ->
    it "should handle nested url"

  describe 'to Metatags', ->
    it "should handle nested url"

  describe 'to Users', ->
    GenericActions 'user'
    it "should test current user"