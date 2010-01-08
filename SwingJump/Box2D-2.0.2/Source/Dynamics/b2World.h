/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

#ifndef B2_WORLD_H
#define B2_WORLD_H

#include "../Common/b2Math.h"
#include "../Common/b2BlockAllocator.h"
#include "../Common/b2StackAllocator.h"
#include "b2ContactManager.h"
#include "b2WorldCallbacks.h"

struct b2AABB;
struct b2ShapeDef;
struct b2BodyDef;
struct b2JointDef;
class b2Body;
class b2Joint;
class b2Shape;
class b2Contact;
class b2BroadPhase;
class b2Controller;
class b2ControllerDef;

struct b2TimeStep
{
	float32 dt;			// time step
	float32 inv_dt;		// inverse time step (0 if dt == 0).
	float32 dtRatio;	// dt * inv_dt0
	int32 velocityIterations;
	int32 positionIterations;
	bool warmStarting;
};

/// The world class manages all physics entities, dynamic simulation,
/// and asynchronous queries. The world also contains efficient memory
/// management facilities.
class b2World
{
public:
	/// Construct a world object.
	/// @param worldAABB a bounding box that completely encompasses all your shapes.
	/// @param gravity the world gravity vector.
	/// @param doSleep improve performance by not simulating inactive bodies.
	b2World(const b2AABB& worldAABB, const b2Vec2& gravity, bool doSleep);

	/// Destruct the world. All physics entities are destroyed and all heap memory is released.
	~b2World();

	/// Register a destruction listener.
	void SetDestructionListener(b2DestructionListener* listener);

	/// Register a broad-phase boundary listener.
	void SetBoundaryListener(b2BoundaryListener* listener);

	/// Register a contact filter to provide specific control over collision.
	/// Otherwise the default filter is used (b2_defaultFilter).
	void SetContactFilter(b2ContactFilter* filter);

	/// Register a contact event listener
	void SetContactListener(b2ContactListener* listener);

	/// Register a routine for debug drawing. The debug draw functions are called
	/// inside the b2World::Step method, so make sure your renderer is ready to
	/// consume draw commands when you call Step().
	void SetDebugDraw(b2DebugDraw* debugDraw);

	/// Create a rigid body given a definition. No reference to the definition
	/// is retained.
	/// @warning This function is locked during callbacks.
	b2Body* CreateBody(const b2BodyDef* def);

	/// Destroy a rigid body given a definition. No reference to the definition
	/// is retained. This function is locked during callbacks.
	/// @warning This automatically deletes all associated shapes and joints.
	/// @warning This function is locked during callbacks.
	void DestroyBody(b2Body* body);

	/// Create a joint to constrain bodies together. No reference to the definition
	/// is retained. This may cause the connected bodies to cease colliding.
	/// @warning This function is locked during callbacks.
	b2Joint* CreateJoint(const b2JointDef* def);

	/// Destroy a joint. This may cause the connected bodies to begin colliding.
	/// @warning This function is locked during callbacks.
	void DestroyJoint(b2Joint* joint);

	/// Add a controller to the world.
	b2Controller* CreateController(b2ControllerDef* def);

	/// Removes a controller from the world.
	void DestroyController(b2Controller* controller);

	/// The world provides a single static ground body with no collision shapes.
	/// You can use this to simplify the creation of joints and static shapes.
	b2Body* GetGroundBody();

	/// Take a time step. This performs collision detection, integration,
	/// and constraint solution.
	/// @param timeStep the amount of time to simulate, this should not vary.
	/// @param velocityIterations for the velocity constraint solver.
	/// @param positionIterations for the position constraint solver.
	void Step(float32 timeStep, int32 velocityIterations, int32 positionIterations);

	/// Query the world for all shapes that potentially overlap the
	/// provided AABB. You provide a shape pointer buffer of specified
	/// size. The number of shapes found is returned.
	/// @param aabb the query box.
	/// @param shapes a user allocated shape pointer array of size maxCount (or greater).
	/// @param maxCount the capacity of the shapes array.
	/// @return the number of shapes found in aabb.
	int32 Query(const b2AABB& aabb, b2Shape** shapes, int32 maxCount);

	/// Query the world for all shapes that intersect a given segment. You provide a shap
	/// pointer buffer of specified size. The number of shapes found is returned, and the buffer
	/// is filled in order of intersection
	/// @param segment defines the begin and end point of the ray cast, from p1 to p2.
	/// Use b2Segment.Extend to create (semi-)infinite rays
	/// @param shapes a user allocated shape pointer array of size maxCount (or greater).
	/// @param maxCount the capacity of the shapes array
	/// @param solidShapes determines if shapes that the ray starts in are counted as hits.
	/// @param userData passed through the worlds contact filter, with method RayCollide. This can be used to filter valid shapes
	/// @returns the number of shapes found
	int32 Raycast(const b2Segment& segment, b2Shape** shapes, int32 maxCount, bool solidShapes, void* userData);

	/// Performs a raycast as with Raycast, finding the first intersecting shape.
	/// @param segment defines the begin and end point of the ray cast, from p1 to p2.
	/// Use b2Segment.Extend to create (semi-)infinite rays	
	/// @param lambda returns the hit fraction. You can use this to compute the contact point
	/// p = (1 - lambda) * segment.p1 + lambda * segment.p2.
	/// @param normal returns the normal at the contact point. If there is no intersection, the normal
	/// is not set.
	/// @param solidShapes determines if shapes that the ray starts in are counted as hits.
	/// @returns the colliding shape shape, or null if not found
	b2Shape* RaycastOne(const b2Segment& segment, float32* lambda, b2Vec2* normal, bool solidShapes, void* userData);

	/// Check if the AABB is within the broadphase limits.
	bool InRange(const b2AABB& aabb) const;

	/// Get the world body list. With the returned body, use b2Body::GetNext to get
	/// the next body in the world list. A NULL body indicates the end of the list.
	/// @return the head of the world body list.
	b2Body* GetBodyList();

	/// Get the world joint list. With the returned joint, use b2Joint::GetNext to get
	/// the next joint in the world list. A NULL joint indicates the end of the list.
	/// @return the head of the world joint list.
	b2Joint* GetJointList();

	/// Get the world controller list. With the returned controller, use b2Controller::GetNext to get
	/// the next controller in the world list. A NULL controller indicates the end of the list.
	/// @return the head of the world controller list.
	b2Controller* GetControllerList();

	/// Re-filter a shape. This re-runs contact filtering on a shape.
	void Refilter(b2Shape* shape);

	/// Enable/disable warm starting. For testing.
	void SetWarmStarting(bool flag) { m_warmStarting = flag; }

	/// Enable/disable continuous physics. For testing.
	void SetContinuousPhysics(bool flag) { m_continuousPhysics = flag; }

	/// Perform validation of internal data structures.
	void Validate();

	/// Get the number of broad-phase proxies.
	int32 GetProxyCount() const;

	/// Get the number of broad-phase pairs.
	int32 GetPairCount() const;

	/// Get the number of bodies.
	int32 GetBodyCount() const;

	/// Get the number of joints.
	int32 GetJointCount() const;

	/// Get the number of contacts (each may have 0 or more contact points).
	int32 GetContactCount() const;

	/// Get the number of controllers.
	int32 GetControllerCount() const;

	/// Change the global gravity vector.
	void SetGravity(const b2Vec2& gravity);
	
	/// Get the global gravity vector.
	b2Vec2 GetGravity() const;

//private:

	friend class b2Body;
	friend class b2ContactManager;
	friend class b2Controller;

	void Solve(const b2TimeStep& step);
	void SolveTOI(const b2TimeStep& step);

	void DrawJoint(b2Joint* joint);
	void DrawShape(b2Shape* shape, const b2XForm& xf, const b2Color& color, bool core);
	void DrawDebugData();

	//Is it safe to pass private static function pointers?
	static float32 RaycastSortKey(void* shape);

	b2BlockAllocator m_blockAllocator;
	b2StackAllocator m_stackAllocator;

	bool m_lock;

	b2BroadPhase* m_broadPhase;
	b2ContactManager m_contactManager;

	b2Body* m_bodyList;
	b2Joint* m_jointList;
	b2Controller* m_controllerList;

	b2Vec2 m_raycastNormal;
	void* m_raycastUserData;
	const b2Segment* m_raycastSegment;
	bool m_raycastSolidShape;


	// Do not access
	b2Contact* m_contactList;

	int32 m_bodyCount;
	int32 m_contactCount;
	int32 m_jointCount;
	int32 m_controllerCount;

	b2Vec2 m_gravity;
	bool m_allowSleep;

	b2Body* m_groundBody;

	b2DestructionListener* m_destructionListener;
	b2BoundaryListener* m_boundaryListener;
	b2ContactFilter* m_contactFilter;
	b2ContactListener* m_contactListener;
	b2DebugDraw* m_debugDraw;

	// This is used to compute the time step ratio to
	// support a variable time step.
	float32 m_inv_dt0;

	// This is for debugging the solver.
	bool m_warmStarting;

	// This is for debugging the solver.
	bool m_continuousPhysics;
};

inline b2Body* b2World::GetGroundBody()
{
	return m_groundBody;
}

inline b2Body* b2World::GetBodyList()
{
	return m_bodyList;
}

inline b2Joint* b2World::GetJointList()
{
	return m_jointList;
}

inline b2Controller* b2World::GetControllerList()
{
	return m_controllerList;
}

inline int32 b2World::GetBodyCount() const
{
	return m_bodyCount;
}

inline int32 b2World::GetJointCount() const
{
	return m_jointCount;
}

inline int32 b2World::GetContactCount() const
{
	return m_contactCount;
}

inline int32 b2World::GetControllerCount() const
{
	return m_controllerCount;
}

inline void b2World::SetGravity(const b2Vec2& gravity)
{
	m_gravity = gravity;
}

inline b2Vec2 b2World::GetGravity() const
{
	return m_gravity;
}

#endif
