public class ScheduleMeetingsController{
    public boolean showStage1{get;set;}
    public boolean showStage2{get;set;}
    public boolean showStage3{get;set;}
    public boolean showStage4{get;set;}
    public boolean showStage5{get;set;}
    
    public ScheduleMeetingsController(){
        goOnStage1();
    }
    
    public void goOnStage1(){
        makeAllHide();
        showStage1 = true;
    }
    
    public void goOnStage2(){
        makeAllHide();
        showStage2 = true;
    }
    
    public void goOnStage3(){
        makeAllHide();
        showStage3 = true;
    }
    
    public void goOnStage4(){
        makeAllHide();
        showStage4 = true;
    }
    
    public void goOnStage5(){
        makeAllHide();
        showStage5 = true;
    }
    
    private void makeAllHide(){
        showStage1 = false;
        showStage2 = false;
        showStage3 = false;
        showStage4 = false;
        showStage5 = false;
    }
}