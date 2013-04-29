Sense = require './src/sense.js'

sense = new Sense()
sense2 = new Sense()

# sense.setServer 'dev'

# console.log 'Sense:', sense.getServer()
# console.log 'Sense2:', sense2.getServer()


sense.createSession 'roemer', 'aa89a3ef3b275e9b72678aadb908cdec', (error, response) ->
  # console.log 'Error:', error if error?
  # console.log 'Response:', response.object

  sense.device 7682, (error, response) ->
  #   console.log 'Error:', error, response if error?
    # console.log 'Devices:', response.object

    # sense.deleteSession (error, response) ->



# console.log sense2.authenticate('user2', 'pass2')


# console.log 'calling devices:', sense.getDevices()

# console.log sense.session_id

sense2.createSession 'josvdh', 'f7b44a43bd6e9d56a544c568836516b5', (error, response) ->
    # sense2.getDevices {}, (error, response) ->
      # console.log 'Devices jos:', response.object
      sense2.sensors (error, response) ->
        console.log response.object
