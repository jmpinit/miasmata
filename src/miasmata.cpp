#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <math.h>
#include <iostream>
using namespace std;

#include "SDL/SDL.h"
#include "SDL/SDL_Draw.h"

//Screen attributes
const int SCREEN_WIDTH = 1600;
const int SCREEN_HEIGHT = 900;
const int SCREEN_BPP = 32;

SDL_Surface *screen = NULL;

SDL_Event event;

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int iCmdShow) {
    return main(__argc, __argv);
}

int main(int argc, char* args[]) {
    SDL_Surface* screen = NULL;
    
    //Set up screen
    screen = SDL_SetVideoMode(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_BPP, SDL_SWSURFACE | SDL_FULLSCREEN);
    
    //Set the window caption
    SDL_WM_SetCaption("slosh", NULL );
    
    Uint32 c_white  = SDL_MapRGB(screen->format, 255,255,255);
    
	//Start SDL
    SDL_Init(SDL_INIT_EVERYTHING);
    
	//While there's an event to handle
	bool quit = false;
	
	while(!quit) {
        //Update Screen
    	SDL_Flip(screen);
        
        while(SDL_PollEvent(&event)) {
            if(event.type == SDL_QUIT) {
                //Quit the program
                quit = true;
            } else if(event.type == SDL_KEYDOWN) {
                switch(event.key.keysym.sym) {
                    case SDLK_LEFT:
                        cx -= 1;
                        break;
                    case SDLK_RIGHT:
                        cx += 1;
                        break;
                    case SDLK_UP:
                        cz += 1;
                        break;
                    case SDLK_DOWN:
                        cz -= 1;
                        break;
                    case SDLK_0:
                        ez += 10;
                        break;
                    case SDLK_1:
                        ez -= 10;
                        break;
                    case SDLK_q:
                        quit = true;
                        break;
                }
            }
        }
    }

    //Quit SDL
    SDL_Quit();

    return 0;
}
