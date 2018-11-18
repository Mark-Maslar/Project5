const starDefinition = artifacts.require('StarNotary')

contract('StarNotary', accounts => { 
    var owner = accounts[0]
    var contractInstance 

    beforeEach(async function () { 
        contractInstance = await starDefinition.new({from: owner})
    })

    describe('can create a star', () => {
        it('can create a star and read its properties', async function () {
            const result0 = await contractInstance.createStar('an awesome star', 'some story', '11', '21', '31', '41');
            const result1 = await contractInstance.tokenIdToStarInfo(1);
            assert.deepEqual(result1, ['an awesome star', 'ra_100', 'dec_010', 'mag_001', 'some story']);

            const result2 = await uint256(contractInstance.getStarHash('1', '2', '3'));
            assert.deepEqual(result0[1], result2);
        });
    }); 
    
    describe('checkIfStarExists', () => {
        it('can return a bool based on star coordinates', async function () {
            await contractInstance.createStar('an awesome star', 'some story', '100', '200', '300', '400');
            const result = await contractInstance.checkIfStarExists('100', '200', '300');
            assert.deepEqual(result, true);
        });
    });      

    // describe('StaryNotary basics', () => { 
    //     it('has correct name', async function () { 
    //         assert.equal(await contractInstance.starName(), 'Awesome Udacity Star')
    //     });

    //     it('can be claimed', async function () { 
    //         assert.equal(await contractInstance.starOwner(), 0)
    //         await contractInstance.claimStar({from: owner})
    //         assert.equal(await contractInstance.starOwner(), owner)
    //     });
    // });

    // describe('Star can change owners', () => { 
    //     beforeEach(async function () { 
    //         assert.equal(await contractInstance.starOwner(), 0)
    //         await contractInstance.claimStar({from: owner})
    //     })

    //     it('can be claimed by a second user', async function () {
    //         var secondUser = accounts[1]
    //         await contractInstance.claimStar({from: secondUser})

    //         assert.equal(await contractInstance.starOwner(), secondUser)
    //     });
    // });
})