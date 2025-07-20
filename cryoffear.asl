

state("cof")
{
    float pausestate: "hw.dll",0x11119E4;
    float loadingstate: "hw.dll",0x10D279C;
    float cutscenestate: "client.dll",0x18ED64;
    string40 map: "hw.dll",0xF1AA15;
    string13 coopstart: "hw.dll",0x377BD8;
    string40 menu_map: "hw.dll",0x820495;
    float igt: "client.dll",0x1BE920;
    string40 music : "client.dll",0x5440C8;
    string40 ambient : "hw.dll",0x72F11B;
    float savestate: "client.dll", 0x18D1DC;
    float hp: "hw.dll",0x116BED0;
    float canmove: "hw.dll",0x9FDC30;
    float alive: "hw.dll", 0x1F39F0;//client.dll 18CB58
    float alivecoop: "hw.dll", 0x798BFC;
    float demo: "hw.dll", 0x1F39C8;
}

init
{
    vars.flag=1;
    vars.savemap = "";
    vars.maps=0;
    vars.chapters=0;
    vars.savetime=0;
    vars.saveflag=0;
}

startup
{
    vars.TimerModel = new TimerModel { CurrentState = timer };
    settings.Add("Split when entering the level");
    settings.SetToolTip("Split when entering the level",
    "Splits each time you enter the different level(c_<level>.bsp) instead of each chapter only");
    settings.Add("Undo when loading the savefile");
    settings.SetToolTip("Undo when loading the savefile",
    "Undoes as many splits as were made before the loading the savefile (for main campaign only)");
}

start
{
    vars.saveflag=0;
    return (current.map=="c_nightmare.bsp" && current.loadingstate==0)
    ||(current.map=="c_doc_city.bsp" && current.loadingstate==0)
    ||(current.map=="c_rumpel1.bsp" && current.loadingstate==0 && current.cutscenestate == 0)
    ||(current.map=="c_hallo_iambulletproof.bsp" && current.loadingstate==0 && current.cutscenestate == 0)
    ||(current.map=="c_arvuti.bsp" && current.loadingstate==0 && current.cutscenestate == 0)
    ||(current.map=="c_the_stairway1.bsp" && current.loadingstate==0)
    ||(current.coopstart=="coopstart.mp3");
}

reset
{
    if(current.demo==0)
    {
        return current.map=="c_nightmare.bsp"
        |current.map=="c_doc_city.bsp"
        |current.map=="c_rumpel1.bsp"
        |current.map=="c_hallo_iambulletproof.bsp"
        |current.map=="c_arvuti.bsp"
        |current.map=="c_the_stairway1.bsp"
        |current.map=="cof_campaign_01.bsp"
        |current.map=="cof_manhunt_campaign.bsp"
        &&old.igt!=0&&current.igt==0;
    }
    // return current.map=="c_nightmare.bsp"
    // |current.map=="c_doc_city.bsp"
    // |current.map=="c_rumpel1.bsp"
    // |current.map=="c_hallo_iambulletproof.bsp"
    // |current.map=="c_arvuti.bsp"
    // |current.map=="c_the_stairway1.bsp"
    // |current.map=="cof_campaign_01.bsp"
    // |current.map=="cof_manhunt_campaign.bsp"
    // &&old.igt!=0&&current.igt==0
    // &&current.demo!=0;
}

isLoading
{    
                         
    return (current.pausestate !=0)||(current.loadingstate ==0)
    ||(current.cutscenestate !=0&&current.canmove==0)
    ||(current.cutscenestate !=0&&current.map=="c_subway2st3.bsp")//for some reason you gain control during the cutscene
    ||(current.cutscenestate !=0&&current.map=="c_trainscene.bsp")//for some reason you gain control during the cutscene
    ||(current.menu_map=="c_loadgame.bsp")
    ||(current.menu_map=="c_loadgame.bsp"&&current.loadingstate ==0)
    ||(current.menu_map=="c_difficulty_settings.bsp")
    ||(current.menu_map=="c_game_menu1.bsp")
    ||(current.alivecoop!=0)
    ||(current.alive==0);
}

split
{
    if(settings["Split when entering the level"])
    {
        if((old.map!=current.map
        &&current.map!="c_trainscene.bsp"
        &&current.map!="c_broscene.bsp")
        &&vars.flag==1
        ||(current.music=="endmusic1.mp3")//main campaign the worst ending
        ||(current.music=="endmusic2.mp3")//main campaign bad ending
        ||(current.music=="endmusic3.mp3")//main campaign bad ending
        ||(current.music=="endmusic4.mp3")//main campaign good ending
        ||(current.music=="coopend.mp3")//coop
        ||(current.music=="manhunt.mp3")//manhunt
        ||(current.music=="lifelover.mp3")//memories
        ||(current.music=="survive_hotel_terror.mp3")//halloween
        ||(current.music=="collab_csong.mp3")//community
        ||(current.map=="c_doc_ending.bsp"))//docmode
        {
            if(vars.saveflag==1&&vars.flag==1)
            {
                vars.maps+=1;
 
            }
            
            return true;
        }
        else if(old.igt==0&&current.igt>0)
        {
            vars.flag=1;
        }
    }

    else
    {
        if(((old.map=="c_apartmentsick.bsp"&&current.map=="c_basement.bsp")//chapter 1 main campaign
        ||(current.music=="brandon2.mp3" && old.music!="brandon2.mp3")//chapter 2 main campaign
        ||(current.music=="crow.mp3" && old.music!="crow.mp3")//chapter 3 main campaign
        ||(old.map!="c_subwaysick2.bsp" && current.map=="c_subway2st1.bsp")//chapter 4 main campaign
        ||(old.map!="c_bridge.bsp"&&current.map=="c_bridge.bsp")//chapter 5 main campaign
        ||(current.music=="ambience/new_chapter.wav"&&old.music!="ambience/new_chapter.wav"&&current.map=="c_attic.bsp")//chapter 6 main campaign
        ||(current.music=="endmusic1.mp3")//chapter 8 main campaign the worst ending
        ||(current.music=="endmusic2.mp3")//chapter 8 main campaign bad ending
        ||(current.music=="endmusic3.mp3")//chapter 8 main campaign bad ending
        ||(current.music=="endmusic4.mp3")//chapter 7 main campaign good ending 
        ||(old.map!="c_ending1.bsp" && current.map=="c_ending1b.bsp")//chapter 7 main campaign the worst ending
        ||(old.map!="c_ending2.bsp" && current.map=="c_ending2b.bsp")//chapter 7 main campaign bad ending
        ||(old.map!="c_ending3.bsp" && current.map=="c_ending3b.bsp")//chapter 7 main campaign bad ending
        ||(old.map!="c_cof_street.bsp" && current.map=="c_subway1.bsp")//chapter 1 manhunt
        ||(old.map!="c_cof_truckride.bsp" && current.map=="c_foresttrail1.bsp")//chapter 2 manhunt
        ||(current.music=="manhunt.mp3")//chapter 3 manhunt 
        ||(old.map!="c_cof_asylumday.bsp" && current.map=="c_cof_campaign_01_p2.bsp")//chapter 9 coop
        ||(old.map!="c_cof_bridge.bsp" && current.map=="c_cof_campaign_01_p3.bsp")//chapter 10 coop
        ||(old.map!="c_cof_city.bsp" && current.map=="c_cof_campaign_01_p4.bsp")//chapter 11 coop
        ||(current.music=="coopend.mp3")//chapter 12 coop
        ||(current.music=="doctorend.mp3")))//docmode
        {
            if (vars.saveflag==1)
            {
                vars.chapters+=1;

            }
            return true;
        }      
    }
}

gameTime
{
    if (old.savestate!=0 && current.savestate==0&&current.music=="Saved")
    {
        vars.maps=0;
        vars.savemap=current.map;
        vars.saveflag=1;
        vars.savetime=timer.CurrentTime.GameTime.Value.TotalSeconds;
    }   
    
    if((current.menu_map=="c_loadgame.bsp"&&current.loadingstate!=0||current.alive==0)&&vars.saveflag==1)
    {   

        if(settings["Split when entering the level"])
        {
            vars.flag=1;
                    if(vars.maps>=0)
                    {
                        
                        if(settings["Undo when loading the savefile"])
                        {
                            vars.flag=0; 
                            for(int i=0;i<vars.maps;i++)
                            {
                                vars.TimerModel.UndoSplit(); 
                            }
                        } 
                        vars.maps=0;  
                    }    
        }

    else
    {
                if(vars.chapters>=0)
                {  
                    if(settings["Undo when loading the savefile"])
                    {
                    for(int i=0;i<vars.chapters;i++)
                    {
                        vars.TimerModel.UndoSplit(); 
                    } 
                    }
                    vars.chapters=0;   
                }
    }   
          
        return TimeSpan.FromSeconds((vars.savetime));
    }

}