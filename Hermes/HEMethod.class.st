"
I represent a serialized method.

I store all the information needed to regenerate the method in the target image.
I store this information and all the bytecode as a byteArray.
Also I store all the literals that have been transformed to HEExportedLiteral's subclasses

I have:
   - the name
   - the class name
   - the protocol
   - the name of the encoderClass 
   - the number of arguments (useful not to parse the selector, in the target system).
   - the number of temporaries
   - if it is a primitive.
  - the bytecode
  - the literals.

Check the methods #readFrom: and #writeInto: for details of how it is written in the file.
"
Class {
	#name : #HEMethod,
	#superclass : #HEAbstractExported,
	#instVars : [
		'className',
		'name',
		'literals',
		'bytecode',
		'protocol',
		'encoderClassName',
		'numArgs',
		'numTemps',
		'hasPrimitive'
	],
	#category : #'Hermes-Model'
}

{ #category : #accessing }
HEMethod >> bytecode [
	^ bytecode
]

{ #category : #accessing }
HEMethod >> bytecode: anObject [
	bytecode := anObject
]

{ #category : #accessing }
HEMethod >> className [
	^ className
]

{ #category : #accessing }
HEMethod >> className: anObject [
	className := anObject
]

{ #category : #compiling }
HEMethod >> headerFor: anEnvironment [
	| encoderClass|
	"When a method is deserialized its header should be recalculated"
	encoderClass := anEnvironment classNamed: encoderClassName.
	
	^ (CompiledMethod headerFlagForEncoder: encoderClass) + (numArgs bitShift: 24) + (numTemps bitShift: 18) + literals size + (hasPrimitive bitShift: 16)
]

{ #category : #accessing }
HEMethod >> literals [
	^ literals
]

{ #category : #accessing }
HEMethod >> literals: anObject [
	literals := anObject
]

{ #category : #accessing }
HEMethod >> name [
	^ name
]

{ #category : #accessing }
HEMethod >> name: anObject [
	name := anObject
]

{ #category : #printing }
HEMethod >> printOn: aStream [
	aStream
		nextPutAll: 'HEMethod ( ';
		print: name ;
		nextPutAll: ' )'
]

{ #category : #accessing }
HEMethod >> protocol [
	^ protocol
]

{ #category : #accessing }
HEMethod >> protocol: anObject [
	protocol := anObject
]

{ #category : #reading }
HEMethod >> readFrom: aReader [
	| numberOfLiterals |

	name := aReader readByteSymbol.
	className := aReader readByteSymbol.
	protocol := aReader readByteSymbol.
		
	encoderClassName := aReader readByteString.
	numArgs := aReader readUInt32.
	numTemps := aReader readUInt32.
	hasPrimitive := aReader readUInt32.

	bytecode := aReader readByteArray.

	numberOfLiterals := aReader readInt32.
	literals := Array new: numberOfLiterals.
	1 to: numberOfLiterals do: [ :idx | literals at:idx put: (HEExportedLiteral readFrom: aReader) ]
]

{ #category : #accessing }
HEMethod >> selector [
	^ self name
]
