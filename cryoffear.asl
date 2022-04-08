

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
    float alive: "client.dll", 0x18CB58;
    float alivecoop: "hw.dll", 0x798BFC;
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
    "Undoes as many splits as were made before the loading the savefile");
}

start
{
    vars.saveflag=0;
    return (current.map=="c_nightmare.bsp" && current.loadingstate==0)
    ||(current.map=="c_doc_city.bsp" && current.loadingstate==0)
    ||(current.coopstart=="coopstart.mp3");
}

reset
{
    return current.map=="c_nightmare.bsp"
    |current.map=="c_doc_city.bsp"
    |current.map=="cof_campaign_01.bsp"
    |current.map=="cof_manhunt_campaign.bsp"
    &&old.igt!=0&&current.igt==0;
}

isLoading
{    
                         
    return (current.pausestate !=0)||(current.loadingstate ==0)
    ||(current.cutscenestate !=0&&current.canmove==0)
    ||(current.menu_map=="c_loadgame.bsp")
    ||(current.menu_map=="c_loadgame.bsp"&&current.loadingstate ==0)
    ||(current.menu_map=="c_difficulty_settings.bsp")
    ||(current.menu_map=="c_game_menu1.bsp")
    ||(current.alivecoop!=0)
    ||(current.alive!=0);
}

split
{
    if(settings["Split when entering the level"])
    {
        if((old.map!=current.map
        &&current.map!="c_trainscene.bsp"
        &&current.map!="c_broscene.bsp")
        &&vars.flag==1
        ||(current.music=="endmusic1.mp3")
        ||(current.music=="endmusic2.mp3")
        ||(current.music=="endmusic3.mp3")
        ||(current.music=="endmusic4.mp3")
        ||(current.map=="c_doc_ending.bsp"))
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
        if(((old.map=="c_apartmentsick.bsp"&&current.map=="c_basement.bsp")
        ||(current.music=="brandon2.mp3" && old.music!="brandon2.mp3")
        ||(current.music=="crow.mp3" && old.music!="crow.mp3")
        ||(old.map!="c_subwaysick2.bsp" && current.map=="c_subway2st1.bsp")
        ||(old.map!="c_bridge.bsp"&&current.map=="c_bridge.bsp")
        ||(current.music=="ambience/new_chapter.wav"&&old.music!="ambience/new_chapter.wav"&&current.map=="c_attic.bsp")
        ||(current.music=="endmusic4.mp3")
        ||(current.music=="doctorend.mp3")))
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
    
    if((current.menu_map=="c_loadgame.bsp"&&current.loadingstate!=0||current.alive!=0)&&vars.saveflag==1)
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