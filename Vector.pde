class Vector{
  //----Instance Variables----//
  private double dx;
  private double dy;
  private double dz;
  
  //----Constructor----//
  public Vector(double dx, double dy, double dz){
    this.dx = dx;
    this.dy = dy;
    this.dz = dz;
  }
  
  //----Setters----//
  public void setDx(double dx){
    this.dx = dx;
  }
  
  public void setDy(double dy){
    this.dy = dy;
  }
  
  public void setDz(double dz){
    this.dz = dz;
  }
  
  //----Getters----//
  public double getDx(){
    return dx;
  }
  
  public double getDy(){
    return dy;
  }
  
  public double getDz(){
    return dz;
  }
  
  //----Methods----//
  
  public Vector copy(){
    return new Vector(dx,dy,dz);
  }
  
  public void print(){
    println(""+str((float)dx)+", "+str((float)dy)+", "+str((float)dz));
  }
  
  
  //----Vector Operations----//
  
  public Vector add(Vector other){
    return new Vector(dx+other.dx,dy+other.dy,dz+other.dz);
  }
  
  public Vector subtract(Vector other){
    return new Vector(dx-other.dx,dy-other.dy,dz-other.dz);
  }
  
  public Vector scale(double scalar){
    return new Vector(dx*scalar,dy*scalar,dz*scalar);
  }
  
  public double dot(Vector other){
    return dx * other.dx + dy * other.dy + dz * other.dz;
  }
  
  //----Other Methods----//
  
  public double length(){
    return Math.sqrt(Math.pow(dx,2)+Math.pow(dy,2)+Math.pow(dz,2));
  }
  
  public Vector normalize(){
    double length = this.length();
    if(length == 0){
      println("Attempted Normalization of Zero Vector");
      exit();
    }
    return this.scale(1/length);
  }
  
  public double dist(Vector other){
    return Math.sqrt(Math.pow((dx-other.dx),2)+Math.pow((dy-other.dy),2)+Math.pow((dz-other.dz),2));
  }
  
  
  
}
