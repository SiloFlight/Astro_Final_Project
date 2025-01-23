class Particle{
  //----Class Variables----//
  private final double G = 6.6743e-11;
  //----Instance Variables----//
  private Vector Position,Velocity;
  private Vector Acceleration = new Vector(0,0,0);
  private Vector CurrentForce = new Vector(0,0,0);
  private Node Parent;
  private color C = color(255,255,255);
  
  private double Mass,Radius;
  
  public Particle(Vector Position, Vector Velocity, double Mass, double Radius){
    this.Position = Position.copy();
    this.Velocity = Velocity.copy();
    
    this.Mass = Mass;
    this.Radius = Radius;
  }
  
  public Particle(Vector Position, Vector Velocity, double Mass, double Radius, color C){
    this.Position = Position.copy();
    this.Velocity = Velocity.copy();
    
    this.Mass = Mass;
    this.Radius = Radius;
    
    this.C = C;
  }
  
  //----Getters----//
  
  public Vector getPosition(){
    return Position;
  }
  
  public Vector getVelocity(){
    return Velocity;
  }
  
  public Vector getAcceleration(){
    return Acceleration;
  }
  
  public double getMass(){
    return Mass;
  }
  
  public double getRadius(){
    return Radius;
  }
  
  
  //----Setters----//
  public void setPosition(Vector P){
    Position = P.copy();
  }
  
  public void setVelocity(Vector V){
    this.Velocity = V.copy();
  }
  
  public void setMass(double Mass){
    this.Mass = Mass;
  }
  
  public void setParent(Node Parent){
    this.Parent = Parent;
  }
  
  //----Methods----//
  
  public void GetForces(){
    //Gets the forces from all other particles in the same node
    for(Particle Other: Parent.getParticleList()){
      if(Other != this){
        AddForce(CalculateForce(Other));
      }
    }
    
    Node Previous = Parent;
    Node Next = Parent.getParent();
    
    //Iterates up the tree while getting the approximate gravitational influence of neighbors.
    while(Next != null){
      Node[][][] SubNodes = Next.getSubNodes();
      
      for(int i = 0; i < 2; i++){
        for(int j = 0; j < 2; j++){
          for(int k = 0; k < 2; k++){
            if(SubNodes[i][j][k] != Previous){
              Particle Other = SubNodes[i][j][k].getCofMass();
              AddForce(CalculateForce(Other));
            }
          }
        }
      }
      
      Previous = Next;
      Next = Next.getParent();
      
    }
  }
  
  public Vector CalculateForce(Particle P){
    //Calculates the Force from other Particle onto this Particle
    //My Collisiion system is assuming that they have no influence on each other
    if(P.getMass()==0 || Mass == 0 || P.getPosition().dist(Position)< P.getRadius()+Radius){
      return new Vector(0,0,0);
    }
    double Dist = Position.dist(P.getPosition());
   
    double Scalar = G * Mass * P.getMass()/(Dist*Dist);
    
    Vector toVector = P.getPosition().subtract(Position).normalize();
    
    return toVector.scale(Scalar);
  }
  
  public void AddForce(Vector Force){
    CurrentForce = CurrentForce.add(Force);
  }
  
  public void ApplyForce(){
    Acceleration = CurrentForce.scale(1/Mass);
    
    CurrentForce = new Vector(0,0,0);
  }
  
  public void ApplyAcceleration(double dt){
    Velocity = Velocity.add(Acceleration.scale(dt));
    
    Acceleration = new Vector(0,0,0);
  }
  
  public void ApplyVelocity(double dt){
    Position = Position.add(Velocity.scale(dt));
    Parent.RemoveParticle(this);
    
    Node Root = Parent;
    while(Root.getParent() != null){
      Root = Root.getParent();
    }
    
   // O(n*rootDepth)
    Parent = Root.InsertParticle(this);
  }
  

  public void drawSelf(double SpaceScale){
    fill(C);
    stroke(C);
    ellipse((float)(Position.getDx()/SpaceScale),(float)(Position.getDy()/SpaceScale),10,7);
  }
}
