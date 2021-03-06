[![Build Status](https://travis-ci.org/senseobservationsystems/commonsense-nodejs-module.png?branch=master)](https://travis-ci.org/senseobservationsystems/commonsense-nodejs-module)

*This module is under heavy development.*

# Commonsense API module

Retrieve information from the [CommonSense](http://www.sense-os.nl/commonsense) platform, using asynchronous http(s) calls.
This module works for both Node.js as just in the browser. In the browser it depends upon the native `XMLHttpRequest` (or ancient `ActiveXObject` for `IE ≤ 6`) object. When used in Node.js, it uses the [node-XMLHttpRequest](https://github.com/driverdan/node-XMLHttpRequest) package.

This API is heavily inspired by [Commonsense-javascript-lib](https://github.com/senseobservationsystems/commonsense-javascript-lib), although this can be seen as an replacement by providing asynchronous call. The naming convention of [Commonsense-javascript-lib](https://github.com/senseobservationsystems/commonsense-javascript-lib) is changed to a more REST-style.

## Install

### NPM
Commonsense-node is available in NPM:

`npm install commonsense`

To include it in your node project, add `"commonsense"` to your `package.json`.

### Bower

`bower install commonsense`


## Usage

This library can be used within a Node.js application and in the browser.

When available in your project, the following is a typical beginning of a usecase.

````coffeescript
  sense = new Sense()
  username = 'some_username'
  password = 'md5_of_password'

  sense.createSession username, password, (error, response) ->
    sense.devices (error, response) ->
      console.log 'Devices:', response.object
````

Please look at the [examples](examples) for embedding in a [Node.js application](examples/simple.coffee) or a [browser script](examples/simple.html).

## Example projects
This is a list of public example projects which use this library:

- [Secare](http://secare.herokuapp.com) ([GitHub repo](https://github.com/rvlasveld/secare)): An online segmentation tool for data from the CommonSense platform.
- [Sense Power](http://sensepower.herokuapp.com) ([GitHub repo](https://github.com/josvdh/sensepower)): Model-Predictive-Control (MPC) of electronic devices hooked up to the CommonSense platform.

## API calls

The following api calls on the Sense object are implemented.
The calls follow the REST-style with the verbs (create, update, delete) prefixed.
An index (list) action corresponds with the plural form and a single get with the single form.
The callback is of the form `next(err, response)`.
The `data` argument is an optional object of headers.

```coffeescript
  # H E L P E R  M E T H O D S #
  optimalInterval: (start, end, amount = 1000) ->

  # A U T H E N T I C A T I O N #
  createSession: (u, p, next) ->
  deleteSession: ([ data, ] next) ->

  # D A T A P R O C E S S O R S #
  dataProcessors: ([ data, ] next) ->
  dataProcessor: (id, [ data, ] next) ->
  createDataProcessor: ([ data, ] next) ->
  updateDataProcessor: (id, [ data, ] next) ->
  deleteDataProcessor: (id, [ data, ] next) ->

  # D A T A  P R O C E S S O R S  &  F I L E S #
  dataProcessorsFiles: ([ data, ] next) ->
  dataProcessorFile: (filename, [ data, ] next) ->
  createDataProcessorsFile: (filename, [ data, ] next) ->
  updateDataProcessorsFile: (filename, [ data, ] next) ->
  deleteDataProcessorsFile: (filename, [ data, ] next) ->

  # D E V I C E S #
  devices: ([ data, ] next) ->
  device: (id, [ data, ] next) ->
  deviceSensors: (id, [ data, ] next) ->

  # E N V I R O N M E N T S #
  # TODO: implement subenvironments
  environments: ([ data, ] next) ->
  environment: (id, [ data, ] next) ->
  createEnvironment: ([ data, ] next) ->
  updateEnvironment: (id, [ data, ] next) ->
  deleteEnvironment: (id, [ data, ] next) ->

  # E N V I R O N M E N T S  &  S E N S O R S #
  environmentSensors: (id, [ data, ] next) ->
  createEnvironmentSensor: (id, [ data, ] next) ->
  deleteEnvironmentSensor: (id, sensor, next) ->

  # G R O U P S #
  allGroups: ([ data, ] next) ->
  groups: ([ data, ] next) ->
  group: (id, [ data, ] next) ->
  createGroup: ([ data, ] next) ->
  updateGroup: (id, [ data, ] next) ->
  deleteGroup: (id, [ data, ] next) ->

  # G R O U P S  &  U S E R S #
  groupUsers: (id, [ data, ] next) ->
  groupUser: (id, user, next) ->
  createGroupUser: (id, [ data, ] next) ->
  updateGroupUser: (id, user, [ data, ] next) ->
  deleteGroupUser: (id, user, next) ->

  # G R O U P S  &  S E N S O R S #
  groupSensors: (id, [ data, ] next) ->
  createGroupSensor: (id, [ data, ] next) ->
  deleteGroupSensor: (id, sensor, next) ->

  # S E N S O R S #
  sensors: ([ data, ] next) ->
  sensor: (id, [ data, ] next) ->
  createSensor: ([ data, ] next) ->
  updateSensor: (id, [ data, ] next) ->
  deleteSensor: (id, [ data, ] next) ->
  sensorsFind: (namespace, [ data, ] next) ->
  findOrCreateSensor: (sensor, next) ->

  # S E N S O R S  &  D A T A #
  sensorData: (id, [ data, ] next) ->
  createSensorData: (id, [ data, ] next) ->
  createSensorsData: ([ data, ] next) ->
  deleteSensorData: (id, data_id, [ data, ] next) ->

  # S E N S O R S  &  E N V I R O N M E N T S #
  sensorEnvironments: (id, [ data, ] next) ->
  # S E N S O R S  &  D E V I C E S #
  sensorDevice: (id, [ data, ] next) ->
  createSensorDevice: (id, [ data, ] next) ->
  deleteSensorDevice: (id, [ data, ] next) ->

  # S E N S O R S  &  S E R V I C E S #
  sensorsAvailableServices: ([ data, ] next) ->
  sensorRunningServices: (id, [ data, ] next) ->
  sensorAvailableServices: (id, [ data, ] next) ->
  createSensorService: (id, [ data, ] next) ->
  deleteSensorService: (id, service, next) ->
  sensorServiceMethods: (id, service, next) ->
  sensorServiceLearn: (id, service, [ data, ] next) ->
  sensorServiceMethod: (id, service, method, next) ->
  createSensorServiceMethod: (id, service, method, [ data, ] next) ->

  # M E T A T A G S #
  sensorsMetatags: ([ data, ] next) ->
  sensorMetatags: (id, [ data, ] next) ->
  createSensorMetatags: (id, [ data, ] next) ->
  updateSensorMetatags: (id, [ data, ] next) ->
  deleteSensorMetaTags: (id, [ data, ] next) ->

  # U S E R S #
  currentUser: ([ data, ] next) ->
  users: ([ data, ] next) ->
  user: (id, [ data, ] next) ->
  createUser: ([ data, ] next) ->
  updateUser: (id, [ data, ] next) ->
  deleteUser: (id, [ data, ] next) ->
```

## Changelog

See the [changelog](CHANGELOG.md) for details of changes.

## Testing

To test the library, please modify `test/api_urls.coffee` by providing your username and md5 password. **Please rememeber to remove these before a commit**.

Run `npm test` from the commandline to run the tests.

## Contributing

1. Fork this repository
2. Clone it on your local machine
3. Install developer dependencies:<br />
`npm install`
4. Create a topic branch:<br />
`git checkout -d feature`
5. **Make your changes**
6. Verify that your changes do not break anything:<br />
`npm test`
7. Add tests if you introduced new functionality in `test/`
8. Push your changes to your fork:<br />
`git push -u [YOUR_FORK] feature`
9. Open a pull request describing your changes:<br />
`git pull-request`
