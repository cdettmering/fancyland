local FileManager = require(FILEPATH .. 'FileManager')
local LayerFile = require(FILEPATH .. 'LayerFile')

function testfile_layer()
    print(FileManager.loadLayerFile('content/levels/testLevel/test_bg.layer'))
end

function testfile_enemy()
    print(FileManager.loadEnemyMapFile('content/levels/testLevel/test.enemymap'))
end
