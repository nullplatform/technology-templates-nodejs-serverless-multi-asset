exports.handler = async (event) => {
    return {
        statusCode: 200,
        body: JSON.stringify({
            message: 'Hello, from function TWO using Node.js!',
            input: event,
        }),
    };
};
