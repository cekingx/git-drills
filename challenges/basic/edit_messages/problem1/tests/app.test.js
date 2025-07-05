const request = require('supertest');
const app = require('../src/app');

describe('API Tests', () => {
    test('GET / should return Hello World', async () => {
        const response = await request(app).get('/');
        expect(response.text).toBe('Hello World!');
    });

    test('GET /api/users should require authentication', async () => {
        const response = await request(app).get('/api/users');
        expect(response.status).toBe(401);
    });
});
