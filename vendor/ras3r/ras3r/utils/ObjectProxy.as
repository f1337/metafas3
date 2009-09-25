////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2006 Adobe Macromedia Software LLC and its licensors.
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

// copied from mx.utils.ObjectProxy in Flex2 SDK
package ras3r.utils
{

import flash.events.*;
import flash.utils.getQualifiedClassName;
import flash.utils.IDataInput;
import flash.utils.IDataOutput;
import flash.utils.IExternalizable;
import flash.utils.Proxy;
import flash.utils.flash_proxy;

use namespace flash_proxy;

[Bindable("propertyChange")]


public dynamic class ObjectProxy
	extends Proxy
	implements IEventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function ObjectProxy(item:Object = null)
    {
        super();

        if (!item)
            item = {};
        _item = item;

        dispatcher = new EventDispatcher(this);
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  A reference to the EventDispatcher for this proxy.
     */
    protected var dispatcher:EventDispatcher;

    /**
     *  Indicates what kind of proxy to create
     *  when proxying complex properties.
     *  Subclasses should assign this value appropriately.
     */
    protected var proxyClass:Class = ObjectProxy;
    
    /**
     *  Contains a list of all of the property names for the proxied object.
     *  Descendants need to fill this list by overriding the
     *  <code>setupPropertyList()</code> method.
     */
    protected var propertyList:Array;

    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  object
    //----------------------------------

    /**
     *  Storage for the object property.
     */
    private var _item:Object;


    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns the specified property value of the proxied object.
     *
     *  @param name Typically a string containing the name of the property,
     *  or possibly a QName where the property name is found by 
     *  inspecting the <code>localName</code> property.
     *
     *  @return The value of the property.
     *  In some instances this value may be an instance of 
     *  <code>ObjectProxy</code>.
     */
    override flash_proxy function getProperty(name:*):*
    {
        // if we have a data proxy for this then
        var result:Object = null;

        result = _item[name];
        
        return result;
    }
    
    /**
     *  Returns the value of the proxied object's method with the specified name.
     *
     *  @param name The name of the method being invoked.
     *
     *  @param rest An array specifying the arguments to the
     *  called method.
     *
     *  @return The return value of the called method.
     */
    override flash_proxy function callProperty(name:*, ... rest):*
    {
        return _item[name].apply(_item, rest)
    }

    /**
     *  Deletes the specified property on the proxied object and
     *  sends notification of the delete to the handler.
     * 
     *  @param name Typically a string containing the name of the property,
     *  or possibly a QName where the property name is found by 
     *  inspecting the <code>localName</code> property.
     *
     *  @return A Boolean indicating if the property was deleted.
     */
    override flash_proxy function deleteProperty(name:*):Boolean
    {
        var oldVal:Object = _item[name];
        var deleted:Boolean = delete _item[name]; 
        return deleted;
    }

    /**
     *  This is an internal function that must be implemented by 
     *  a subclass of flash.utils.Proxy.
     *  
     *  @param name The property name that should be tested 
     *  for existence.
     *
     *  @see flash.utils.Proxy#hasProperty()
     */
    override flash_proxy function hasProperty(name:*):Boolean
    {
        return(name in _item);
    }
    
    /**
     *  This is an internal function that must be implemented by 
     *  a subclass of flash.utils.Proxy.
     *
     *  @see flash.utils.Proxy#nextName()
     */
    override flash_proxy function nextName(index:int):String
    {
        return propertyList[index -1];
    }
    
    /**
     *  This is an internal function that must be implemented by 
     *  a subclass of flash.utils.Proxy.
     *
     *  @see flash.utils.Proxy#nextNameIndex()
     */
    override flash_proxy function nextNameIndex(index:int):int
    {
        if (index == 0)
        {
            setupPropertyList();
        }
        
        if (index < propertyList.length)
        {
            return index + 1;
        }
        else
        {
            return 0;
        }
    }
    
    /**
     *  This is an internal function that must be implemented by 
     *  a subclass of flash.utils.Proxy.
     *
     *  @see flash.utils.Proxy#nextValue()
     */
    override flash_proxy function nextValue(index:int):*
    {
        return _item[propertyList[index -1]];
    }

    /**
     *  Updates the specified property on the proxied object
     *  and sends notification of the update to the handler.
     *
     *  @param name Object containing the name of the property that
     *  should be updated on the proxied object.
     *
     *  @param value Value that should be set on the proxied object.
     */
    override flash_proxy function setProperty(name:*, value:*):void
    {
        var oldVal:* = _item[name];
        if (oldVal !== value)
        {
            // Update item.
            _item[name] = value;
        }
    }



    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Registers an event listener object  
     *  so that the listener receives notification of an event. 
     *  For more information, see the flash.events.EventDispatcher class.
     *
     *  @see flash.events.EventDispatcher#addEventListener()
     */
    public function addEventListener(type:String, listener:Function,
                                     useCapture:Boolean = false,
                                     priority:int = 0,
                                     useWeakReference:Boolean = false):void
    {
        dispatcher.addEventListener(type, listener, useCapture,
                                    priority, useWeakReference);
    }

    /**
     *  Removes an event listener. 
     *  If there is no matching listener registered with the EventDispatcher object, 
     *  a call to this method has no effect.
     *  For more information, see the flash.events.EventDispatcher class.
     *
     *  @see flash.events.EventDispatcher#removeEventListener()
     */
    public function removeEventListener(type:String, listener:Function,
                                        useCapture:Boolean = false):void
    {
        dispatcher.removeEventListener(type, listener, useCapture);
    }

    /**
     *  Dispatches an event into the event flow. 
     *  For more information, see the flash.events.EventDispatcher class.
     *
     *  @see flash.events.EventDispatcher#dispatchEvent()
     */
    public function dispatchEvent(event:Event):Boolean
    {
        return dispatcher.dispatchEvent(event);
    }
    
    /**
     *  Checks whether there are any event listeners registered 
     *  for a specific type of event. 
     *  This allows you to determine where an object has altered handling 
     *  of an event type in the event flow hierarchy. 
     *  For more information, see the flash.events.EventDispatcher class.
     *
     *  @see flash.events.EventDispatcher#hasEventListener()
     */
    public function hasEventListener(type:String):Boolean
    {
        return dispatcher.hasEventListener(type);
    }
    
    /**
     *  Checks whether an event listener is registered with this object 
     *  or any of its ancestors for the specified event type. 
     *  This method returns <code>true</code> if an event listener is triggered 
     *  during any phase of the event flow when an event of the specified 
     *  type is dispatched to this object or any of its descendants.
     *  For more information, see the flash.events.EventDispatcher class.
     *
     *  @see flash.events.EventDispatcher#willTrigger()
     */
    public function willTrigger(type:String):Boolean
    {
        return dispatcher.willTrigger(type);
    }

    
    //--------------------------------------------------------------------------
    //
    //  Protected Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  This method creates an array of all of the property names for the 
     *  proxied object.
     *  Descendants must override this method if they wish to add more 
     *  properties to this list.
     *  Be sure to call <code>super.setupPropertyList</code> before making any
     *  changes to the <code>propertyList</code> property.
     */
    protected function setupPropertyList():void
    {
        if (getQualifiedClassName(_item) == "Object")
        {
            propertyList = [];
            for (var prop:String in _item)
                propertyList.push(prop);
        }
        else
        {
//            propertyList = ObjectUtil.getClassInfo(_item, null, {includeReadOnly:true, uris:["*"]}).properties;
        }
    }
}

}
