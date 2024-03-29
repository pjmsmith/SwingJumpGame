#include "Biped.h"
#include "BipedDef.h"
#define PI 3.14159

BipedDef* def = new BipedDef();
b2BodyDef bd;

Biped::Biped(b2World* w, const b2Vec2& position)				
{
	m_world = w;

	// create body parts
	bd = def->LFootDef;
	bd.position += position;
	LFoot = w->CreateBody(&bd);
	LFoot->CreateShape(&(def->LFootPoly));
	LFoot->SetMassFromShapes();

	bd = def->RFootDef;
	bd.position += position;
	RFoot = w->CreateBody(&bd);
	RFoot->CreateShape(&(def->RFootPoly));
	RFoot->SetMassFromShapes();

	bd = def->LCalfDef;
	bd.position += position;
	LCalf = w->CreateBody(&bd);
	LCalf->CreateShape(&(def->LCalfPoly));
	LCalf->SetMassFromShapes();

	bd = def->RCalfDef;
	bd.position += position;
	RCalf = w->CreateBody(&bd);
	RCalf->CreateShape(&(def->RCalfPoly));
	RCalf->SetMassFromShapes();

	bd = def->LThighDef;
	bd.position += position;
	LThigh = w->CreateBody(&bd);
	LThigh->CreateShape(&(def->LThighPoly));
	LThigh->SetMassFromShapes();

	bd = def->RThighDef;
	bd.position += position;
	RThigh = w->CreateBody(&bd);
	RThigh->CreateShape(&(def->RThighPoly));
	RThigh->SetMassFromShapes();

	bd = def->PelvisDef;
	bd.position += position;
	Pelvis = w->CreateBody(&bd);
	Pelvis->CreateShape(&(def->PelvisPoly));
	Pelvis->SetMassFromShapes();

	bd = def->PelvisDef;
	bd.position += position;
	Stomach = w->CreateBody(&bd);
	Stomach->CreateShape(&(def->StomachPoly));
	Stomach->SetMassFromShapes();

	bd = def->ChestDef;
	bd.position += position;
	Chest = w->CreateBody(&bd);
	Chest->CreateShape(&def->ChestPoly);
	Chest->SetMassFromShapes();

	bd = def->NeckDef;
	bd.position += position;
	Neck = w->CreateBody(&bd);
	Neck->CreateShape(&(def->NeckPoly));
	Neck->SetMassFromShapes();

	bd = def->HeadDef;
	bd.position += position;
	Head = w->CreateBody(&bd);
	Head->CreateShape(&(def->HeadCirc));
	Head->SetMassFromShapes();

	bd = def->LUpperArmDef;
	bd.position += position;
	LUpperArm = w->CreateBody(&bd);
	LUpperArm->CreateShape(&(def->LUpperArmPoly));
	LUpperArm->SetMassFromShapes();

	bd = def->RUpperArmDef;
	bd.position += position;
	RUpperArm = w->CreateBody(&bd);
	RUpperArm->CreateShape(&(def->RUpperArmPoly));
	RUpperArm->SetMassFromShapes();

	bd = def->LForearmDef;
	bd.position += position;
	LForearm = w->CreateBody(&bd);
	LForearm->CreateShape(&(def->LForearmPoly));
	LForearm->SetMassFromShapes();

	bd = def->RForearmDef;
	bd.position += position;
	RForearm = w->CreateBody(&bd);
	RForearm->CreateShape(&(def->RForearmPoly));
	RForearm->SetMassFromShapes();

	bd = def->LHandDef;
	bd.position += position;
	LHand = w->CreateBody(&bd);
	LHand->CreateShape(&(def->LHandPoly));
	LHand->SetMassFromShapes();

	bd = def->RHandDef;
	bd.position += position;
	RHand = w->CreateBody(&bd);
	RHand->CreateShape(&(def->RHandPoly));
	RHand->SetMassFromShapes();
	
	// link body parts
	def->LAnkleDef.body1		= LFoot;
	def->LAnkleDef.body2		= LCalf;
	def->RAnkleDef.body1		= RFoot;
	def->RAnkleDef.body2		= RCalf;
	def->LKneeDef.body1		= LCalf;
	def->LKneeDef.body2		= LThigh;
	def->RKneeDef.body1		= RCalf;
	def->RKneeDef.body2		= RThigh;
	def->LHipDef.body1		= LThigh;
	def->LHipDef.body2		= Pelvis;
	def->RHipDef.body1		= RThigh;
	def->RHipDef.body2		= Pelvis;
	def->LowerAbsDef.body1	= Pelvis;
	def->LowerAbsDef.body2	= Stomach;
	def->UpperAbsDef.body1	= Stomach;
	def->UpperAbsDef.body2	= Chest;
	def->LowerNeckDef.body1	= Chest;
	def->LowerNeckDef.body2	= Neck;
	def->UpperNeckDef.body1	= Chest;
	def->UpperNeckDef.body2	= Head;
	def->LShoulderDef.body1	= Chest;
	def->LShoulderDef.body2	= LUpperArm;
	def->RShoulderDef.body1	= Chest;
	def->RShoulderDef.body2	= RUpperArm;
	def->LElbowDef.body1		= LForearm;
	def->LElbowDef.body2		= LUpperArm;
	def->RElbowDef.body1		= RForearm;
	def->RElbowDef.body2		= RUpperArm;
	def->LWristDef.body1		= LHand;
	def->LWristDef.body2		= LForearm;
	def->RWristDef.body1		= RHand;
	def->RWristDef.body2		= RForearm;
	
	// create joints
	LAnkle		= (b2RevoluteJoint*)w->CreateJoint(&(def->LAnkleDef));
	RAnkle		= (b2RevoluteJoint*)w->CreateJoint(&(def->RAnkleDef));
	LKnee		= (b2RevoluteJoint*)w->CreateJoint(&(def->LKneeDef));
	RKnee		= (b2RevoluteJoint*)w->CreateJoint(&(def->RKneeDef));
	LHip		= (b2RevoluteJoint*)w->CreateJoint(&(def->LHipDef));
	RHip		= (b2RevoluteJoint*)w->CreateJoint(&(def->RHipDef));
	LowerAbs	= (b2RevoluteJoint*)w->CreateJoint(&(def->LowerAbsDef));
	UpperAbs	= (b2RevoluteJoint*)w->CreateJoint(&(def->UpperAbsDef));
	LowerNeck	= (b2RevoluteJoint*)w->CreateJoint(&(def->LowerNeckDef));
	UpperNeck	= (b2RevoluteJoint*)w->CreateJoint(&(def->UpperNeckDef));
	LShoulder	= (b2RevoluteJoint*)w->CreateJoint(&(def->LShoulderDef));
	RShoulder	= (b2RevoluteJoint*)w->CreateJoint(&(def->RShoulderDef));
	LElbow		= (b2RevoluteJoint*)w->CreateJoint(&(def->LElbowDef));
	RElbow		= (b2RevoluteJoint*)w->CreateJoint(&(def->RElbowDef));
	LWrist		= (b2RevoluteJoint*)w->CreateJoint(&(def->LWristDef));
	RWrist		= (b2RevoluteJoint*)w->CreateJoint(&(def->RWristDef));
}
void Biped::PumpFwdLimits()
{
	//LHip->SetLimits(-45.0*PI/180.0f,-45.0*PI/180.0);
	//RHip->SetLimits(-45.0*PI/180.0f,-45.0*PI/180.0);
	LowerAbs->SetLimits(-60.0*PI/180.0f,-60.0*PI/180.0);
	UpperAbs->SetLimits(-45.0*PI/180.0f,-45.0*PI/180.0);
	LKnee->SetLimits(0.0f,0.0f);
	RKnee->SetLimits(0.0f,0.0f);
	LAnkle->SetLimits(0.523598776f,0.523598776f);
	RAnkle->SetLimits(0.523598776f,0.523598776f);
	//LowerNeck->SetLimits(0.0f,0.0f);
	//UpperNeck->SetLimits(0.0f,0.0f);
}

void Biped::PumpBckwdLimits()
{
	LHip->SetLimits(-60.0f*PI/180.0f,-60.0f*PI/180.0);
	RHip->SetLimits(-60.0f*PI/180.0f,-60.0f*PI/180.0);
	LowerAbs->SetLimits(-25.0f*PI/180.0f,-25.0f*PI/180.0);
	UpperAbs->SetLimits(-30.0f*PI/180.0f,-30.0f*PI/180.0);
	LKnee->SetLimits(2.61799388f,2.61799388f);
	RKnee->SetLimits(2.61799388f,2.61799388f);
	LAnkle->SetLimits(-0.523598776f,-0.523598776f);
	RAnkle->SetLimits(-0.523598776f,-0.523598776f);
	//LowerNeck->SetLimits(0.0f,0.0f);
	//UpperNeck->SetLimits(0.0f,0.0f);
}	
void Biped::SetSittingLimits()
{
	LAnkle->SetLimits(-0.523598776f,0.523598776f);
	RAnkle->SetLimits(-0.523598776f,0.523598776f);
	LKnee->SetLimits(0.0f,2.61799388f);
	RKnee->SetLimits(0.0f,2.61799388f);
	LHip->SetLimits(-45.0*PI/180.0f,-45.0*PI/180.0);
	RHip->SetLimits(-45.0*PI/180.0f,-45.0*PI/180.0);
	LowerAbs->SetLimits(-45.0*PI/180.0f,-45.0*PI/180.0);
	UpperAbs->SetLimits(-45.0*PI/180.0f,-45.0*PI/180.0);
	LowerNeck->SetLimits(0.0f,0.0f);
	UpperNeck->SetLimits(0.0f,0.0f);
	LShoulder->SetLimits(-20.0*PI/180.0f, 10.0*PI/180.0f);
	RShoulder->SetLimits(-20.0*PI/180.0f, 10.0*PI/180.0f);
	LElbow->SetLimits(-1.6f,-1.6f);
	RElbow->SetLimits(-1.6f,-1.6f);
	LWrist->SetLimits(-1.0f,-1.0f);
	RWrist->SetLimits(-1.0f,-1.0f);	
	
	LAnkle->EnableMotor(false);
	RAnkle->EnableMotor(false);
	LKnee->EnableMotor(false);
	RKnee->EnableMotor(false);
	LHip->EnableMotor(false);
	RHip->EnableMotor(false);
	LowerAbs->EnableMotor(false);
	UpperAbs->EnableMotor(false);
	LowerNeck->EnableMotor(false);
	UpperNeck->EnableMotor(false);
	LShoulder->EnableMotor(false);
	RShoulder->EnableMotor(false);
	LElbow->EnableMotor(false);
	RElbow->EnableMotor(false);
	LWrist->EnableMotor(false);
	RWrist->EnableMotor(false);	
}
void Biped::SetDefaultLimits()
{
	LAnkle->SetLimits(-0.523598776f,0.523598776f);
	RAnkle->SetLimits(-0.523598776f,0.523598776f);
	LKnee->SetLimits(0.0f,2.61799388f);
	RKnee->SetLimits(0.0f,2.61799388f);
	LHip->SetLimits(-2.26892803f,0.0f);
	RHip->SetLimits(-2.26892803f,0.0f);
	LowerAbs->SetLimits(-0.523598776f,0.523598776f);
	UpperAbs->SetLimits(-0.523598776f,0.174532925f);
	LowerNeck->SetLimits(-0.174532925f,0.174532925f);
	UpperNeck->SetLimits(-0.610865238f,0.785398163f);
	LShoulder->SetLimits(-1.04719755f,3.14159265f);
	RShoulder->SetLimits(-1.04719755f,3.14159265f);
	LElbow->SetLimits(-2.7925268f,0);
	RElbow->SetLimits(-2.7925268f,0);
	LWrist->SetLimits(-0.174532925f,0.174532925f);
	RWrist->SetLimits(-0.174532925f,0.174532925f);	
	
	LAnkle->EnableMotor(true);
	RAnkle->EnableMotor(true);
	LKnee->EnableMotor(true);
	RKnee->EnableMotor(true);
	LHip->EnableMotor(true);
	RHip->EnableMotor(true);
	LowerAbs->EnableMotor(true);
	UpperAbs->EnableMotor(true);
	LowerNeck->EnableMotor(true);
	UpperNeck->EnableMotor(true);
	LShoulder->EnableMotor(true);
	RShoulder->EnableMotor(true);
	LElbow->EnableMotor(true);
	RElbow->EnableMotor(true);
	LWrist->EnableMotor(true);
	RWrist->EnableMotor(true);	
}
void Biped::SetLinearVelocity(const b2Vec2& velocity)
{
	
	LFoot->SetLinearVelocity(velocity);
	RFoot->SetLinearVelocity(velocity);
	LCalf->SetLinearVelocity(velocity);
	RCalf->SetLinearVelocity(velocity);
	LThigh->SetLinearVelocity(velocity);
	RThigh->SetLinearVelocity(velocity);
	Pelvis->SetLinearVelocity(velocity);
	Stomach->SetLinearVelocity(velocity);
	Chest->SetLinearVelocity(velocity);
	Neck->SetLinearVelocity(velocity);
	Head->SetLinearVelocity(velocity);
	LUpperArm->SetLinearVelocity(velocity);
	RUpperArm->SetLinearVelocity(velocity);
	LForearm->SetLinearVelocity(velocity);
	RForearm->SetLinearVelocity(velocity);
	LHand->SetLinearVelocity(velocity);
	RHand->SetLinearVelocity(velocity);
}
void Biped::ApplyImpulse(const b2Vec2& impulse, const b2Vec2& point)
{
	
	LFoot->ApplyImpulse(impulse, point);
	RFoot->ApplyImpulse(impulse, point);
	LCalf->ApplyImpulse(impulse, point);
	RCalf->ApplyImpulse(impulse, point);
	LThigh->ApplyImpulse(impulse, point);
	RThigh->ApplyImpulse(impulse, point);
	Pelvis->ApplyImpulse(impulse, point);
	Stomach->ApplyImpulse(impulse, point);
	Chest->ApplyImpulse(impulse, point);
	Neck->ApplyImpulse(impulse, point);
	Head->ApplyImpulse(impulse, point);
	LUpperArm->ApplyImpulse(impulse, point);
	RUpperArm->ApplyImpulse(impulse, point);
	LForearm->ApplyImpulse(impulse, point);
	RForearm->ApplyImpulse(impulse, point);
	LHand->ApplyImpulse(impulse, point);
	RHand->ApplyImpulse(impulse, point);
}

void Biped::PutToSleep()
{
	
	LFoot->PutToSleep();
	RFoot->PutToSleep();
	LCalf->PutToSleep();
	RCalf->PutToSleep();
	LThigh->PutToSleep();
	RThigh->PutToSleep();
	Pelvis->PutToSleep();
	Stomach->PutToSleep();
	Chest->PutToSleep();
	Neck->PutToSleep();
	Head->PutToSleep();
	LUpperArm->PutToSleep();
	RUpperArm->PutToSleep();
	LForearm->PutToSleep();
	RForearm->PutToSleep();
	LHand->PutToSleep();
	RHand->PutToSleep();
}
void Biped::SetBullet()
{
	
	LFoot->SetBullet(true);
	RFoot->SetBullet(true);
	LCalf->SetBullet(true);
	RCalf->SetBullet(true);
	LThigh->SetBullet(true);
	RThigh->SetBullet(true);
	Pelvis->SetBullet(true);
	Stomach->SetBullet(true);
	Chest->SetBullet(true);
	Neck->SetBullet(true);
	Head->SetBullet(true);
	LUpperArm->SetBullet(true);
	RUpperArm->SetBullet(true);
	LForearm->SetBullet(true);
	RForearm->SetBullet(true);
	LHand->SetBullet(true);
	RHand->SetBullet(true);
}

void Biped::SetLinearDamping(float damp)
{
	
	LFoot->m_linearDamping = damp;
	RFoot->m_linearDamping = damp;
	LCalf->m_linearDamping = damp;
	RCalf->m_linearDamping = damp;
	LThigh->m_linearDamping = damp;
	RThigh->m_linearDamping = damp;
	Pelvis->m_linearDamping = damp;
	Stomach->m_linearDamping = damp;
	Chest->m_linearDamping = damp;
	Neck->m_linearDamping = damp;
	Head->m_linearDamping = damp;
	LUpperArm->m_linearDamping = damp;
	RUpperArm->m_linearDamping = damp;
	LForearm->m_linearDamping = damp;
	RForearm->m_linearDamping = damp;
	LHand->m_linearDamping = damp;
	RHand->m_linearDamping = damp;
}
void Biped::SetAngularDamping(float damp)
{
	
	LFoot->m_angularDamping = damp;
	RFoot->m_angularDamping = damp;
	LCalf->m_angularDamping = damp;
	RCalf->m_angularDamping = damp;
	LThigh->m_angularDamping = damp;
	RThigh->m_angularDamping = damp;
	Pelvis->m_angularDamping = damp;
	Stomach->m_angularDamping = damp;
	Chest->m_angularDamping = damp;
	Neck->m_angularDamping = damp;
	Head->m_angularDamping = damp;
	LUpperArm->m_angularDamping = damp;
	RUpperArm->m_angularDamping = damp;
	LForearm->m_angularDamping = damp;
	RForearm->m_angularDamping = damp;
	LHand->m_angularDamping = damp;
	RHand->m_angularDamping = damp;
}

void Biped::DestroyAllJoints()
{
	m_world->DestroyJoint(LAnkle);
	m_world->DestroyJoint(RAnkle);
	m_world->DestroyJoint(LKnee);
	m_world->DestroyJoint(RKnee);
	m_world->DestroyJoint(LHip);
	m_world->DestroyJoint(RHip);
	m_world->DestroyJoint(LowerAbs);
	m_world->DestroyJoint(UpperAbs);
	m_world->DestroyJoint(LowerNeck);
	m_world->DestroyJoint(UpperNeck);
	m_world->DestroyJoint(LShoulder);
	m_world->DestroyJoint(RShoulder);
	m_world->DestroyJoint(LElbow);
	m_world->DestroyJoint(RElbow);
	m_world->DestroyJoint(LWrist);
	m_world->DestroyJoint(RWrist);
}

Biped::~Biped(void)
{
	m_world->DestroyBody(LFoot);
	m_world->DestroyBody(RFoot);
	m_world->DestroyBody(LCalf);
	m_world->DestroyBody(RCalf);
	m_world->DestroyBody(LThigh);
	m_world->DestroyBody(RThigh);
	m_world->DestroyBody(Pelvis);
	m_world->DestroyBody(Stomach);
	m_world->DestroyBody(Chest);
	m_world->DestroyBody(Neck);
	m_world->DestroyBody(Head);
	m_world->DestroyBody(LUpperArm);
	m_world->DestroyBody(RUpperArm);
	m_world->DestroyBody(LForearm);
	m_world->DestroyBody(RForearm);
	m_world->DestroyBody(LHand);
	m_world->DestroyBody(RHand);
}

void Biped::setLaunched(bool z) {
	launchStatus = z;
}

bool Biped::hasLaunched(){
	return launchStatus;
}