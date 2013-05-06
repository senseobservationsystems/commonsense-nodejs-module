[![Build Status](https://travis-ci.org/senseobservationsystems/commonsense-nodejs-module.png?branch=master)](https://travis-ci.org/https://travis-ci.org/senseobservationsystems/commonsense-nodejs-module)

# Commonsense Node.js Module

Retrieve information from the [CommonSense](http://www.sense-os.nl/commonsense) platform, using asynchronous http calls.

This module is under development.

The API mainly follows the one from [Commonsense-javascript-lib](https://github.com/senseobservationsystems/commonsense-javascript-lib), although the functions names have been changed to reflect a REST-style.

## Install

Commonsense-node is available in NPM:

`npm install commonsense`

To include it in your node project, add `"commonsense"` to your `package.json`.

## API calls

The following api calls on the Sense object are implemented.
The calls follow the REST-style with the verbs (create, update, delete) prefixed.
An index (list) action corresponds with the plural form and a single get with the single form.
The callback is of the form `next(err, response)`.

```coffeescript
  # A U T H E N T I C A T I O N #
  createSession: (u, p, next)
  deleteSession: (next)

  # D A T A P R O C E S S O R S #
  dataProcessors: (next)
  dataProcessor: (id, next)
  createDataProcessor: (data, next)
  updateDataProcessor: (id, data, next)
  deleteDataProcessor: (id, next)

  # D A T A  P R O C E S S O R S  &  F I L E S #
  dataProcessorsFiles: (next)
  dataProcessorFile: (filename, next)
  createDataProcessorsFile: (filename, data, next)
  updateDataProcessorsFile: (filename, data, next)
  deleteDataProcessorsFile: (filename, next)

  # D E V I C E S #
  devices: (next)
  device: (id, next)
  deviceSensors: (id, next)

  # E N V I R O N M E N T S #
  environments: (next)
  environment: (id, next)
  createEnvironment: (data, next)
  updateEnvironment: (id, data, next)
  deleteEnvironment: (id, next)

  # E N V I R O N M E N T S  &  S E N S O R S #
  environmentSensors: (id, next)
  createEnvironmentSensor: (id, data, next)
  deleteEnvironmentSensor: (id, sensor, next )

  # G R O U P S #
  allGroups: (next)
  groups: (next)
  group: (id, next)
  createGroup: (data, next)
  updateGroup: (id, data, next)
  deleteGroup: (id, next)

  # G R O U P S  &  U S E R S #
  groupUsers: (id, next)
  groupUser: (id, user, next)
  createGroupUser: (id, data, next)
  updateGroupUser: (id, user, data, next)
  deleteGroupUser: (id, user, next)

  # G R O U P S  &  S E N S O R S #
  groupSensors: (id, next)
  createGroupSensor: (id, data, next )
  deleteGroupSensor: (id, sensor, next )

  # S E N S O R S #
  sensors: (next)
  sensor: (id, next)
  createSensor: (data, next)
  updateSensor: (id, data, next)
  deleteSensor: (id, next)
  sensorsFind: (namespace, data, next)

  # S E N S O R S  &  D A T A #
  sensorData: (id, next)
  createSensorData: (id, data, next)
  createSensorsData: (data, next)
  deleteSensorData: (id, data_id, next)

  # S E N S O R S  &  E N V I R O N M E N T S #
  sensorEnvironments: (id, next)

  # S E N S O R S  &  D E V I C E S #
  sensorDevice: (id, next)
  createSensorDevice: (id, data, next)
  deleteSensorDevice: (id, next)

  # S E N S O R S  &  S E R V I C E S #
  sensorsAvailableServices: (next)
  sensorRunningServices: (id, next)
  sensorAvailableServices: (id, next)
  createSensorService: (id, data, next)
  deleteSensorService: (id, service, next)
  sensorServiceMethods: (id, service, next)
  sensorServiceLearn: (id, service, data, next)
  sensorServiceMethod: (id, service, method, next)
  createSensorServiceMethod: (id, service, method, data, next)

  # M E T A T A G S #
  sensorsMetatags: (next)
  sensorMetatags: (id, next)
  createSensorMetatags: (id, data, next)
  updateSensorMetatags: (id, data, next)
  deleteSensorMetaTags: (id, next)

  # U S E R S #
  currentUsers: (next)
  users: (next)
  user: (id, next)
  createUser: (next)
  updateUser: (id, data, next)
  deleteUser: (id, next)
```

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