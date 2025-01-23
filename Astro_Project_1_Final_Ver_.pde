//Env Variables
int WindowX = 1200;
int WindowY = 1200;

int Iterations = (int)1e3;

long Time = 0;

long MaxTime = (long)1e10;

//Step Length(In Seconds);
double dt = 1e5;

//The expected bounds of the simulation
double SimSize = 1e14;

//The amount of subdivisions that should be taken, the #Nodes is 8^SimGranularity.
int SimGranularity = 2;

//The level of spatial compression of the render
double SpaceScale = 1e13;

Node Root;
Renderer Render;
ArrayList<Particle> ParticleList = new ArrayList<Particle>();

int m = millis();

//Needed inorder to pass variables into size(), blame processing
void settings(){
  size(WindowX,WindowY);
}

void setup(){
  Root = new Node(0,SimGranularity,new Vector(0,0,0),SimSize,null);
  Render = new Renderer(WindowX,WindowY,new Vector(0,0,0), SpaceScale);
  
  //Initialize Planets
  Particle Sun = new Particle(new Vector(0,0,0), new Vector(0,0,0),1.98e30,6.95e8,color(255,255,0));
  
  Particle Mercury = new Particle(new Vector(5.79e10,0,0), new Vector(0,4.74e4,0),3.33e23,4879/2.0,color(160,160,160));
  Particle Venus = new Particle(new Vector(1.08e11,0,0), new Vector(0,3.5e4,0),4.87e24,12104/2.0,color(255,128,0));
  Particle Earth = new Particle(new Vector(1.49e11,0,0), new Vector(0,2.98e4,0),5.97e24,12756/2.0,color(0,255,0));
  Particle Mars = new Particle(new Vector(2.28e11,0,0), new Vector(0,2.41e4,0),6.42e23,6792/2.0,color(204,0,0));
  Particle Jupiter = new Particle(new Vector(7.78e11,0,0), new Vector(0,1.31e4,0),1.89e27,142984/2.0,color(255,153,51));
  Particle Saturn = new Particle(new Vector(1.35e12,0,0), new Vector(0,9.7e3,0),5.68e26,120536/2.0,color(255,255,153));
  Particle Uranus = new Particle(new Vector(2.73e12,0,0), new Vector(0,6.8e3,0),8.68e25,51118/2.0,color(153,255,255));
  Particle Neptune = new Particle(new Vector(4.51e12,0,0), new Vector(0,5.4e3,0),1.02e26,49528/2.0,color(102,102,255));
  
  
  //Add Planets into Particle List
  ParticleList.add(Sun);
  ParticleList.add(Mercury);
  ParticleList.add(Venus);
  ParticleList.add(Earth);
  ParticleList.add(Mars);
  ParticleList.add(Jupiter);
  ParticleList.add(Saturn);
  ParticleList.add(Uranus);
  ParticleList.add(Neptune);
  
  
  //Add Planets into Root Structure
  
  Root.InsertParticle(Sun);
  
  Root.InsertParticle(Mercury);
  
  Root.InsertParticle(Venus);
  Root.InsertParticle(Earth);
  Root.InsertParticle(Mars);
  Root.InsertParticle(Jupiter);
  Root.InsertParticle(Saturn);
  Root.InsertParticle(Uranus);
  Root.InsertParticle(Neptune);
  
  //Add Planets to Renderer
  Render.InsertParticle(Sun);
  Render.InsertParticle(Mercury);
  
  Render.InsertParticle(Venus);
  Render.InsertParticle(Earth);
  Render.InsertParticle(Mars);
  Render.InsertParticle(Jupiter);
  Render.InsertParticle(Saturn);
  Render.InsertParticle(Uranus);
  Render.InsertParticle(Neptune);
  
  Vector SwarmOrigin = new Vector(-1e12,0,0);
  int AsteroidNum = 1;
  double SwarmRadius = 1e6;
  double SwarmMass = 1e32;
  
  ArrayList<Particle> Asteroids = GenerateAsteroidSwarm(AsteroidNum,SwarmOrigin,SwarmRadius,SwarmMass, new Vector(0,-8e3,0));
  
  for(Particle Asteroid: Asteroids){
    Root.InsertParticle(Asteroid);
    ParticleList.add(Asteroid);
    Render.InsertParticle(Asteroid);
  }
  
  Root.UpdateCofMasses();
  println("Completed");
  
}

ArrayList<Particle> GenerateAsteroidSwarm(int n, Vector Center, double radius, double TotalMass, Vector Velocity){
  ArrayList<Particle> Particles = new ArrayList<Particle>(); 
  
  for(int i = 0; i< n; i++){
    Vector Position = randomPointInCircle(Center,radius);
    double Mass;
    //The mass of each asteroid is determined using this algorithm. Randomly choose a percentage between 1/n and .5. That will be the percentage of the remaining mass allocated to this particle. After that remove that mass from the Total Mass and repeat until the final Particle. The final Particle just receives the entirity of the remaining TotalMass.
    if(i < n -1){
      Mass = TotalMass * random(1.0/n,.5);
      TotalMass -= Mass;
    }else{
      //Final Asteroid gets remaining Mass
      Mass = TotalMass;
      TotalMass = 0;
    }
    
    Particle P = new Particle(Position,Velocity, Mass, 1000);
    Particles.add(P);
  }
  
  return Particles;
}

//Returns a uniformly random point within radius of center
Vector randomPointInCircle(Vector Center, double r){
  
  Vector Position = new Vector(random((float)-r,(float)r),random((float)-r,(float)r),0);
  
  while(Position.dist(Center) > r){
    println("Repeated");
    Position = Center.add(new Vector(random((float)-r,(float)r),random((float)-r,(float)r),random((float)-r,(float)r)));
  }
  
  return Position;
}

void LogResults(){
  Particle Sun = ParticleList.get(0);
  Particle Mercury = ParticleList.get(1);
  Particle Venus = ParticleList.get(2);
  Particle Earth = ParticleList.get(3);
  Particle Mars = ParticleList.get(4);
  Particle Jupiter = ParticleList.get(5);
  Particle Saturn = ParticleList.get(6);
  Particle Uranus = ParticleList.get(7);
  Particle Neptune = ParticleList.get(8);
  

  //The Hard coded numbers are their distance from the sun in the base simulation.
  println("Sun is " + (Sun.getPosition().dist(Sun.getPosition())) +" meters out of orbit.");
  println("Mercury is " + (Mercury.getPosition().dist(Sun.getPosition()) - 1.6737561120340106E11) +" meters out of orbit.");
  println("Venus is " + (Venus.getPosition().dist(Sun.getPosition()) - 1.520380761763234E11) +" meters out of orbit.");
  println("Earth is " + (Earth.getPosition().dist(Sun.getPosition()) - 1.4146301727209518E11) +" meters out of orbit.");
  println("Mars is " + (Mars.getPosition().dist(Sun.getPosition()) - 3.0932247871742487E11) +" meters out of orbit.");
  println("Jupiter is " + (Jupiter.getPosition().dist(Sun.getPosition()) - 7.829713563991779E11) +" meters out of orbit.");
  println("Saturn is " + (Saturn.getPosition().dist(Sun.getPosition()) - 1.2502334519259368E12) +" meters out of orbit.");
  println("Uranus is " + (Uranus.getPosition().dist(Sun.getPosition()) - 2.455554957400841E12) + " meters out of orbit.");
  println("Neptune is " + (Neptune.getPosition().dist(Sun.getPosition()) - 4.582824982884316E12) +" meters out of orbit.");
}

void draw(){
  background(0,0,0);
  for(int i = 0; i < Iterations; i++){
    //Particles Calculate their forces and Apply the Force
    for(Particle P: ParticleList){
      P.GetForces();
      P.ApplyForce();
    }
    
    //Particles Apply their Accelerations,Velocities
    for(Particle P: ParticleList){
      P.ApplyAcceleration(dt);
      P.ApplyVelocity(dt);
    }
    
    //Update CofMasses of the Nodes
    Root.UpdateCofMasses();
    
    Time += dt;
  }
  
  
  Render.Render();
  
  if(Time > MaxTime){
    LogResults();
    noLoop();
  }
  println(millis()-m);
  m=millis();
}
