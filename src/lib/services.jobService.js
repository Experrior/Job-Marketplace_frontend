
const apiGateway = import.meta.env.VITE_GATEWAY_URL;
console.log("USING GATEWAY:", apiGateway);


const API_URL = `${apiGateway}/job-service/graphql`;

export async function callGraphQL(query, variables = {}, jwt) {

    try {
        const response = await fetch(API_URL, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${jwt}`,
            },
            body: JSON.stringify({ query, variables }),
        });
        const data = await response.json();
        if (data.errors) {
            console.error("GraphQL errors:", data.errors);
            return null;
        }
        return data.data;
    } catch (error) {
        console.error("Error calling GraphQL API:", error);
        return null;
    }
}

export async function fetchSavedOffers(jwt) {
    const query = `
        query {
            followedJobs {
                jobId
                title
                location
                salary
                createdAt
            }
        }
    `;

    try {
        const result = await callGraphQL(query, {}, jwt);

        if (result && result.followedJobs) {
            return result.followedJobs; // Return the saved offers
        } else {
            console.error('GraphQL error:', result?.errors || "Unknown error");
            throw new Error('Could not load saved offers. Please try again later.');
        }
    } catch (error) {
        console.error('Failed to fetch saved offers:', error);
        throw error;
    }
}
