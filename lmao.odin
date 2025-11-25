package main

import "core:strings"
import "core:fmt"
import rl "vendor:raylib"

main :: proc() {
    rl.SetConfigFlags(rl.ConfigFlags{ .WINDOW_RESIZABLE })

    rl.InitWindow(800, 450, "Moving Ball")
    rl.SetTargetFPS(144)

    ball_pos := rl.Vector2{400,  225 }
    paddle_pos := rl.Vector2{0, f32(rl.GetScreenHeight()/2)}
    paddle_vel := rl.Vector2{0, 2}
    ball_radius : f32 = 20
    score := 0

    for !rl.WindowShouldClose() {
        width  := rl.GetScreenWidth()
        height := rl.GetScreenHeight()

        paddle_pos.y += f32(paddle_vel.y)
        paddle_pos.x += f32(paddle_vel.x)

        if ball_pos.x < ball_radius {
            ball_pos.x = ball_radius
        }

        if  ball_pos.x > f32(width) - ball_radius  {
         ball_pos.x = f32(width) - ball_radius
        } 

        if ball_pos.y < ball_radius {
          ball_pos.y = ball_radius
        }

        if  ball_pos.y > f32(height) - ball_radius  {
          ball_pos.y = f32(height) - ball_radius;
        }

        if paddle_pos.x < 0 || paddle_pos.x + 10 > f32(width){
          paddle_vel = -1 * paddle_vel
        }

        if paddle_pos.y < 0 || paddle_pos.y + 50 > f32(height){
          paddle_vel = -1 * paddle_vel
        }

        if ball_pos.x - ball_radius <= paddle_pos.x + 10 &&
           ball_pos.y + ball_radius >= paddle_pos.y &&
           ball_pos.y - ball_radius <= paddle_pos.y + 50
        {
            score += 1
            ball_pos.x = paddle_pos.x + 50 + ball_radius
        }


        if rl.IsKeyDown(.RIGHT) {ball_pos.x += 10;}
        if rl.IsKeyDown(.LEFT) {ball_pos.x -= 10;}
        if rl.IsKeyDown(.UP) {ball_pos.y -= 10;}
        if rl.IsKeyDown(.DOWN) {ball_pos.y += 10;}

        message := fmt.tprintf("Score: {}" ,score)
        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)

        rl.DrawRectangle(i32(paddle_pos.x), i32(paddle_pos.y), 10, 50, rl.BLUE)
        rl.DrawCircleV(ball_pos, ball_radius, rl.RED)
        rl.DrawText("Not Pong!", 20, 20, 20, rl.DARKGRAY)
        rl.DrawText(strings.clone_to_cstring(message),  width - 150, 20, 20, rl.DARKGRAY)

        rl.EndDrawing()
    }

    rl.CloseWindow()
}

