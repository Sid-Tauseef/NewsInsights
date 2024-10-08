// services/newsAPI.service.js
const axios = require('axios');

class NewsAPIService {
    static async getRecommendations(categories) {
        const apiKey = process.env.NEWS_API_KEY;
        let recommendations = [];

        for (const category of categories) {
            const response = await axios.get(
                `https://newsapi.org/v2/everything?sources=the-times-of-india&apiKey=f920a5d9981e42de91c052c8471db7a2`
            );
            recommendations.push(...response.data.articles);
        }

        return recommendations;
    }
}

module.exports = NewsAPIService;
