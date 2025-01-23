class Renderer{
  
  private ArrayList<Particle> ParticleList = new ArrayList<Particle>();
  
  private int WindowX;
  private int WindowY;
  private Vector Origin;
  private double SpaceScale;
  
  public Renderer(int WindowX, int WindowY, Vector Origin, double SpaceScale){
    this.WindowX = WindowX;
    this.WindowY = WindowY;
    this.Origin = Origin.copy();
    this.SpaceScale = SpaceScale;
  }
  
  //----Setters----//
  public void setOrigin(Vector Origin){
    this.Origin = Origin.copy();
  }
  
  //----Methods----//
  
  public void InsertParticle(Particle P){
    ParticleList.add(P);
  }
  
  public void InsertParticleList(ArrayList<Particle> PList){
    ParticleList.addAll(PList);
  }
   
  public void Render(){
    //Calculate Distance to Translate
    double OriginX = Origin.getDx();
    double OriginY = Origin.getDy();
    
    //Calculates the relative position. (May be slightly buggy as I've only used 0,0 as center)
    int TranslateX = (int)(OriginX/SpaceScale+WindowX/2);
    int TranslateY = (int)(OriginY/SpaceScale+WindowY/2);
    
    
    translate(TranslateX,TranslateY);
    
    //Draw Particles
    for(int i = 0; i < ParticleList.size(); i++){
      Particle P = ParticleList.get(i);
      
      P.drawSelf(SpaceScale);
    }
  }
}
