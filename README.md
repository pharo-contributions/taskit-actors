

### ActIt


TaskIt we are also providing actors, leveraging the whole Taskit implementation, and adding some extra features. Our implementation is inspired by "Actalk: a Testbed for Classifying and Designing Actor Languages in the Smalltalk-80 Environment", but adapted to the new Pharo state-full traits.


#### Actors

The actor's model proposes to provide an interface to interact with a process. Allowing the user of a process to ask for service to a process, by message sending.

To achieve the same kind of behavior in Pharo, we subordinate a process to expose and serve the behavior of an existing object. 



#### Loading ActIt

If you want a specific release, such as v1.0, you can load the associated tag as follows:

```smalltalk
Metacello new
  baseline: 'TaskIt';
  repository: 'github://pharo-contributions/taskit:v1.0';
  load.
```

Otherwise, if you want the latest development version, load the master branch:

```smalltalk
Metacello new
  baseline: 'ActIt';
  repository: 'github://pharo-contributions/taskit-actors';
  load.
```


#### Adding it as a Metacello dependency

Add the following in your metacello configuration or baseline specifying the desired version:

```smalltalk
spec
    baseline: 'ActIt'
    with: [ spec repository: 'github://pharo-contributions/taskit-actors:v1.0' ]
```



#### How to use it

To achieve this, we propose the trait `TKTActorBehavior`, which is responsible for extending a class by adding the method #actor. 

This method will return an instance of the class `TKTActor`, which will act as a proxy (managed by `doesnotUnderstand:` message) to the object but transform the calls into tasks to be executed sequentially.

Each method sent to the actor will return a *future*. 

To make your domain object become an actor, add the usage of the trait `TKTActorBehaviour` as follows:

```smalltalk
Object << #MyDomainObject
	traits: {TKTActorBehaviour};
	package: 'MyDomainObjectPack'
```

##### Example

Let us consider the class #MyDomainObject defined just before, but with an instance variable #value, and the methods #setValue: and #getValue to manage the content of this slot. 

```smalltalk
Object << #MyDomainObject
	traits: {TKTActorBehaviour};
	slots:{#value};
	package: 'MyDomainObjectPack'
	
MyDomainObject>>#getValue
	^ value 
MyDomainObject>>#setValue: aValue
	value := aValue 
```

After adding the mentioned behaviour and instance variable we can now interact with an instance of such a class in two different ways. A synchronic classical way, and a a-synchronic (actor oriented) way.

```smalltalk

"Instantiate the class."
myObject := MyDomainObject new. 

"Synchronic access. "
myObject setValue: 2.

"Please note that getValue responds directly with a number. "
self assert: myObject getValue = 2.

"Obtain an actor handle. "
myActor := myObject actor.
"Please note that the #getValue method, when invoked throught the actor handle, returns a taskit future. "

self assert: (myActor getValue isKindOf: TKTFuture).
self assert: (myActor getValue synchronizeTimeout: 1 second) = myObject getValue. 

```

#### How to act

To add this trait is not enough to make your Object into an Actor. 
You have to keep in mind that any time that you use `smalltalk self` in your object, you are doing a synchronous call. 
That each time that you give your object's reference by parameter instead of the actor's reference, your object will work as a classic object as well.
  
For allowing the user to do async calls to self, the trait provides de property `smalltalk aself` (Async-self). 
  
Remind also that even when actors provide a nice way to avoid simple semaphores, they do not entirely avoid deadlocks since the interaction between actors is possible, desirable, and 
non-regulated.
  



### Conclusion
