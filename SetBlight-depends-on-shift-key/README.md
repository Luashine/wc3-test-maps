# Alleged SetBlight bug

The W3CE guys discovered that the SetBlight native ought to depend on the currently pressed SHIFT key, whether it applies its effect or not.
It was said it would and thus potentially desync between players.

This map runs SetBlight at 0,0 first true then false (said to be affected), later SetBlightLoc true then false (said to not be affected).

Detailed test: https://github.com/lep/jassdoc/issues/105

Thread: https://www.hiveworkshop.com/threads/setblight-desync-issues.350885/

Test map: SetBlight-v2-wc3-v1.27.w3x

## My results

v1.27 TFT: works correctly whether SHIFTs are pressed or not
v1.36: works correctly too

Instead `SetTerrainType(0, 0, FourCC('NOTH'), 0,5,1)` is affected by SHIFT. It sets a fog like around map edges.
