const AWS = require('aws-sdk');
const docClient = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
    const body = JSON.parse(event.body);
    
    let deviceId = body.deviceId;
    let actionArray = body.actionArray;
    
    let sub = await getSub(deviceId);
    await updateUser(sub, actionArray);
    
    const response = {
        statusCode: 200,
        isBase64Encoded: false,
        headers: {},
        multiValueHeaders: {},
        body: JSON.stringify({}),
    };
    return response;
};

function getSub(deviceId) {
    const params = {
        TableName: 'swaste-devicemap-data',
        Key: {
            deviceId
        }
    };
    
    return new Promise( function (resolve) {
        docClient.get(params, function (err, data) {
            if (err) {
                console.log(err);
                return;
            }
            resolve(data.Item.sub);
        });
    });
}

async function updateUser(sub, actionArray) {
    const disposal = {
        time: Math.round(new Date().getTime()/1000),
        actions: actionArray
    };
    
    const params = {
        TableName: 'swaste-user-data',
        Key: {
            sub
        },
        UpdateExpression: 'SET disposalHistory = list_append(disposalHistory, :disposalArray), points = points + :points',
        ExpressionAttributeValues: {
            ':points': actionArray.length,
            ':disposalArray': [disposal]
        }
    };
    
    return new Promise( function (resolve) {
        docClient.update(params, function (err, data) {
            if (err) {
                console.log("Problem updating");
                console.log(err);
                resolve(false);
                return;
            }
            resolve(true);
            console.log("No error");
            console.log(data);
        });
    });
}

