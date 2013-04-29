# Commonsense Node.js Module

This project is the source for the (upcoming) npm commonsense package.

Currently under heavy development.

The API mainly follows the one from [Commonsense-javascript-lib](https://github.com/senseobservationsystems/commonsense-javascript-lib), although this is likely to change.

## API calls

The following api calls on the Sense object are implemented.
The calls follow the REST-style with the verbs (create, update, delete) prefixed.
An index (list) action corresponds with the plural form and a single get with the single form.
In every call `args...` can be any number of arguments, usually an optional data object and always the next callback function `(error, response) ->` as last argument.

```coffeescript
  # A U T H E N T I C A T I O N #
  createSession: (u, p, args...)
  deleteSession: (args...)

  # D A T A P R O C E S S O R S #
  dataProcessors: (args...)
  dataProcessor: (id, args...)
  createDataProcessor: (data, args...)
  updateDataProcessor: (id, data, args...)
  deleteDataProcessor: (id, args...)

  # D A T A  P R O C E S S O R S  &  F I L E S #
  dataProcessorsFiles: (args...)
  dataProcessorFile: (filename, args...)
  createDataProcessorsFile: (filename, data, args...)
  updateDataProcessorsFile: (filename, data, args...)
  deleteDataProcessorsFile: (filename, args...)

  # D E V I C E S #
  devices: (args...)
  device: (id, args...)
  deviceSensors: (id, args...)

  # E N V I R O N M E N T S #
  environments: (args...)
  environment: (id, args...)
  createEnvironment: (data, args...)
  updateEnvironment: (id, data, args...)
  deleteEnvironment: (id, args...)

  # E N V I R O N M E N T S  &  S E N S O R S #
  environmentSensors: (id, args...)
  createEnvironmentSensor: (id, data, args...)
  deleteEnvironmentSensor: (id, sensor, args... )

  # G R O U P S #
  allGroups: (args...)
  groups: (args...)
  group: (id, args...)
  createGroup: (data, args...)
  updateGroup: (id, data, args...)
  deleteGroup: (id, args...)

  # G R O U P S  &  U S E R S #
  groupUsers: (id, args...)
  groupUser: (id, user, args...)
  createGroupUser: (id, data, args...)
  updateGroupUser: (id, user, data, args...)
  deleteGroupUser: (id, user, args...)

  # G R O U P S  &  S E N S O R S #
  groupSensors: (id, args...)
  createGroupSensor: (id, data, args... )
  deleteGroupSensor: (id, sensor, args... )

  # S E N S O R S #
  sensors: (args...)
  sensor: (id, args...)
  createSensor: (data, args...)
  updateSensor: (id, data, args...)
  deleteSensor: (id, args...)
  sensorsFind: (namespace, data, args...)

  # S E N S O R S  &  D A T A #
  sensorData: (id, args...)
  createSensorData: (id, data, args...)
  createSensorsData: (data, args...)
  deleteSensorData: (id, data_id, args...)

  # S E N S O R S  &  E N V I R O N M E N T S #
  sensorEnvironments: (id, args...)

  # S E N S O R S  &  D E V I C E S #
  sensorDevice: (id, args...)
  createSensorDevice: (id, data, args...)
  deleteSensorDevice: (id, args...)

  # S E N S O R S  &  S E R V I C E S #
  sensorsAvailableServices: (args...)
  sensorRunningServices: (id, args...)
  sensorAvailableServices: (id, args...)
  createSensorService: (id, data, args...)
  deleteSensorService: (id, service, args...)
  sensorServiceMethods: (id, service, args...)
  sensorServiceLearn: (id, service, data, args...)
  sensorServiceMethod: (id, service, method, args...)
  createSensorServiceMethod: (id, service, method, data, args...)

  # M E T A T A G S #
  sensorsMetatags: (args...)
  sensorMetatags: (id, args...)
  createSensorMetatags: (id, data, args...)
  updateSensorMetatags: (id, data, args...)
  deleteSensorMetaTags: (id, args...)

  # U S E R S #
  currentUsers: (args...)
  users: (args...)
  user: (id, args...)
  createUser: (args...)
  updateUser: (id, data, args...)
  deleteUser: (id, args...)
```