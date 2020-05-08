Class {
	#name : #BaselineOfActIt,
	#superclass : #BaselineOf,
	#category : #BaselineOfActIt
}

{ #category : #'development support' }
BaselineOfActIt class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>

]

{ #category : #private }
BaselineOfActIt class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #MetacelloBaseConfiguration ifAbsent: aBlock ].

]

{ #category : #catalog }
BaselineOfActIt class >> catalogContactInfo [
	^ 'santiagobragagnolo@gmail.com'
]

{ #category : #catalog }
BaselineOfActIt class >> catalogDescription [
	^ 'Task & Jobs oriented multiprocessing framework. Check for nicely showed documentation at https://github.com/sbragagnolo/taskit-2/ :)'
]

{ #category : #catalog }
BaselineOfActIt class >> catalogKeywords [
	^ {'multiprocessing'. 'futures'. 'tasks'. 'services'. }
]

{ #category : #private }
BaselineOfActIt class >> ensureMetacelloBaseConfiguration [

	Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			| repository version |
			repository := MCHttpRepository location: 'http://seaside.gemstone.com/ss/metacello' user: '' password: ''.
			repository
				versionReaderForFileNamed: 'Metacello-Base-DaleHenrichs.2.mcz'
				do: [ :reader | 
					version := reader version.
					version load.
					version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
BaselineOfActIt class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
BaselineOfActIt class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
BaselineOfActIt class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
BaselineOfActIt class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #baseline }
BaselineOfActIt >> baseline: spec [
	<baseline>
	spec
		baseline: 'TaskIt'
		with: [ spec repository: 'github://pharo-contributions/taskit/src' ].
	spec package: #ActIt with: [ spec requires: #('TaskIt') ].
	spec package: #'ActIt-Tests' with: [ spec requires: #('ActIt') ].
	spec
		group: 'minimal' with: #('ActIt');
		group: 'development' with: #('minimal' #'ActIt-Tests');
		group: 'default' with: #('development')
]

{ #category : #'as yet unclassified' }
BaselineOfActIt >> baselineForCommon: spec [
	spec
		package: #'TaskIt-Tests' with: [ spec requires: #('TaskIt') ];
		package: #TaskItRetry with: [ spec requires: #('TaskIt') ];
		package: #'TaskItRetry-Tests'
			with: [ spec requires: #('TaskItRetry') ];
		package: #TaskItProcesses with: [ spec requires: #('TaskIt') ];
		package: #'TaskItProcesses-Tests'
			with: [ spec requires: #('TaskItProcesses') ];
		package: #TaskItBrowser
			with: [ spec requires: #('TaskItProcesses') ];
		package: #TaskItDebugger
			with: [ spec requires: #('TaskItProcesses') ];
		package: #'TaskItDebugger-Tests'
			with: [ spec requires: #('TaskItDebugger') ].
	spec
		group: 'minimal' with: #('TaskIt');
		group: 'default'
			with:
			#('minimal' 'TaskItProcesses' 'TaskItRetry' 'TaskItDebugger' 'TaskIt-Tests' 'TaskItRetry-Tests' 'TaskItProcesses-Tests' 'TaskItDebugger-Tests');
		group: 'debug' with: #('minimal' 'TaskItDebugger');
		group: 'tests'
			with:
			#('default' 'TaskIt-Tests' 'TaskItRetry-Tests' 'TaskItProcesses-Tests' 'TaskItDebugger-Tests');
		group: 'development' with: #('default' 'debug' 'tests')
]
