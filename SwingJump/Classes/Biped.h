#ifndef BIPED_H
#define BIPED_H

#include "Box2D.h"

// Ragdoll class thanks to darkzerox.
class Biped
{
public:
	Biped(b2World*, const b2Vec2& position);
	~Biped();

	b2World* m_world;

	b2Body				*LFoot, *RFoot, *LCalf, *RCalf, *LThigh, *RThigh,
						*Pelvis, *Stomach, *Chest, *Neck, *Head,
						*LUpperArm, *RUpperArm, *LForearm, *RForearm, *LHand, *RHand;

	b2RevoluteJoint		*LAnkle, *RAnkle, *LKnee, *RKnee, *LHip, *RHip, 
						*LowerAbs, *UpperAbs, *LowerNeck, *UpperNeck,
						*LShoulder, *RShoulder, *LElbow, *RElbow, *LWrist, *RWrist;
	bool launchStatus;
	void SetSittingLimits();
	void SetDefaultLimits();
	void DestroyAllJoints();
	void PumpFwdLimits();
	void PumpBckwdLimits();
	void SetLinearVelocity(const b2Vec2& velocity);
	void ApplyImpulse(const b2Vec2& impulse, const b2Vec2& point);
	void PutToSleep();
	bool hasLaunched();
	void SetBullet();
	void setLaunched(bool);
	void SetLinearDamping(float damp);
	void SetAngularDamping(float damp);
};

#endif
