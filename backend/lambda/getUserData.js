const AWS = require('aws-sdk');
const docClient = new AWS.DynamoDB.DocumentClient();

async function getData(params){
    return new Promise((resolve) => {
        docClient.get(params, function(error, data){
            if(error){
                console.log("Error occured", error);
                resolve({statusCode: error.statusCode, body: error});
            }
            resolve(
                {
                    statusCode: 200, 
                    body: JSON.stringify(data.Item), 
                    headers: {},
                    isBase64Encoded: false,
                    multiValueHeaders: {}
                    
                });
        });
    });
}

exports.handler = async (event) => {
    // TODO implement
    
    const sub = event.headers.sub;
    
    const params = {
        TableName: 'swaste-user-data',
        Key: {
            sub
        },
        ProjectionExpression: 'points, disposalHistory'
    };
    
    const response = await getData(params);
    
    console.log(response);
    
    return response;
};
