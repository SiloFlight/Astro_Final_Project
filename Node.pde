class Node{
  //Sim Method based on Barnes-Hut Method (https://en.wikipedia.org/wiki/Barnes%E2%80%93Hut_simulation)
  private Node Parent;
  private boolean Active = false;
  private int MaxDepth;
  private int Depth;
  private Vector Center;
  private double Size;
  private ArrayList<Particle> ParticleList = new ArrayList<Particle>();
  
  /*
  SubNode[i][j][k],
  i = x
  j = y
  k = z
  
  0 is positive direction
  1 is negative direction(and 0)
  */
  private Node[][][] SubNodes = new Node[2][2][2];
  
  private Particle CofMass;
  private double TotalMass = 0;
  
  public Node(int Depth, int MaxDepth, Vector Center, double Size, Node Parent){
    this.Depth = Depth;
    this.MaxDepth = MaxDepth;
    this.Center = Center.copy();
    this.Size = Size;
    this.Parent = Parent;
    
    //Create InnerNodes
    if(Depth < MaxDepth){
      for(int i = 0; i < 2; i++){
        for(int j = 0; j < 2; j++){
          for(int k = 0; k < 2; k++){
            //Ternaries decide what subnode the particle will be assigned to. a 0 means the center is offset in the negative direction of that axis, a 1 means it is offset in the positive.
            int xScalar = i == 0 ? 1 : -1;
            int yScalar = j == 0 ? 1 : -1;
            int zScalar = k == 0 ? 1 : -1;
            Vector NodeCenter = Center.add(new Vector(xScalar*Size/2,yScalar*Size/2,zScalar*Size/2));
            SubNodes[i][j][k] = new Node(Depth+1,MaxDepth,NodeCenter,Size/2,this);
          }
        }
      }
    }
  }
  //----Getters----//
  public Node getParent(){
    return Parent;
  }
  
  public Particle getCofMass(){
    if(CofMass == null){
      println("Null CofMass");
      UpdateCofMass();
    }
    return CofMass;
  }
  
  public double getTotalMass(){
    return TotalMass;
  }
  
  public Vector getCenter(){
    return Center;
  }
  
  public Node[][][] getSubNodes(){
    return SubNodes;
  }
  
  public int getDepth(){
    return Depth;
  }
  
  public ArrayList<Particle> getParticleList(){
    return ParticleList;
  }
  
  public boolean getActive(){
    return Active;
  }
  
  //----Methods----//
  
  public Node InsertParticle(Particle P){
    Active = true;
    if(Depth < MaxDepth){
      double xComponent = P.getPosition().getDx();
      double yComponent = P.getPosition().getDy();
      double zComponent = P.getPosition().getDz();
      
      //These ternareis decide what subnode the Particle will be assigned to.
      
      int i = xComponent > Center.getDx() ? 0 : 1;
      int j = yComponent > Center.getDy() ? 0 : 1;
      int k = zComponent > Center.getDz() ? 0 : 1;
      
      return SubNodes[i][j][k].InsertParticle(P);
    }else{
      //Once at the lowest level, it is inserted into the list
      ParticleList.add(P);
      P.setParent(this);
      return this;
    }
  }
  
  public void RemoveParticle(Particle P){
    //Assumes that if you're trying to remove the particle, it will be there
    ParticleList.remove(P);
  }
  
  public Particle UpdateCofMasses(){
    if(Depth < MaxDepth){
      TotalMass = 0;
      
      //Update CofMasses and collect Mass
      for(int i = 0; i < 2; i++){
        for(int j = 0; j < 2; j++){
          for(int k = 0; k < 2; k++){
            if(SubNodes[i][j][k].getActive()){
              Particle NodeCofMass = SubNodes[i][j][k].UpdateCofMasses();
              TotalMass += NodeCofMass.getMass();
            }
          }
        }
      }
      
      
      Vector Pos = new Vector(0,0,0);
      
      //Preventing division by 0
      if(TotalMass == 0){
        Active = false;
        CofMass = new Particle(Pos,new Vector(0,0,0),0,0);
        return CofMass;
      }
      
      for(int i = 0; i < 2; i++){
        for(int j = 0; j < 2; j++){
          for(int k = 0; k < 2; k++){
            Pos = Pos.add(SubNodes[i][j][k].getCofMass().getPosition().scale(SubNodes[i][j][k].getTotalMass()/TotalMass));
          }
        }
      }
      
      CofMass = new Particle(Pos,new Vector(0,0,0),TotalMass,0);
      
      return CofMass;
      
    }else{
      return UpdateCofMass();
    }
  }
  
  public Particle UpdateCofMass(){
    TotalMass = 0;
    
    //Determines TotalMass of Particles within
    for(Particle P: ParticleList){
      TotalMass += P.getMass();
    }
    
    Vector Pos = new Vector(0,0,0);
    
    //Prevent division by 0
    if(TotalMass == 0){
      Active = false;
      CofMass = new Particle(Pos,new Vector(0,0,0),0,0);
      return CofMass;
    }
    
    //Calculate CofMass based on proportion of mass.
    for(Particle P: ParticleList){
      Pos = Pos.add(P.getPosition().scale(P.getMass()/TotalMass));
    }
    
    CofMass = new Particle(Pos,new Vector(0,0,0),TotalMass,0);
    
    
    return CofMass;
  }
  
}
