# Early Timer Desync in Lua

Version: 1.32.10 (and older?) - 2.0.3+

2025 bug report: https://us.forums.blizzard.com/en/warcraft3/t/lua-gui-timers-always-desync-minimal-repro/36941

## Quoting myself

8/21/22, 8:57 PM

Please tell me this has been known:
Creating a repeating 0.01s timer in Lua will cause desync (within 15-17s of the timer running)
soon after map load

*link to map download* `EarlyTimerDesyncsLua.w3m`

please test. created in 1.32.10

i could repro with any of the 3 triggers (but the 5s delayed was 50-50% out of 2 tries)
