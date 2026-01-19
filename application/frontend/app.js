// DOM Elements
const touches = [...document.querySelectorAll('.bouton')];
const listeKeycode = touches.map(touche => touche.dataset.key);
const ecran = document.querySelector('.ecran');

// Event Listeners
document.addEventListener('keydown', (e) => {
    const value = e.keyCode.toString();
    handleInput(value);
});

document.addEventListener('click', (e) => {
    const value = e.target.dataset.key;
    handleInput(value);
});

// Main Input Handler
const handleInput = (value) => {
    if (listeKeycode.includes(value)) {
        switch (value) {
            case '8': // KeyCode for 'C' (Clear)
                ecran.textContent = "";
                break;
            case '13': // KeyCode for 'Enter'/'=' (Calculate)
                const expression = ecran.textContent;
                // Prevent empty submission
                if (expression.trim() === "") return;
                
                // Trigger the API flow
                sendCalculation(expression);
                break;
            default:
                // Append numbers and operators to screen
                const indexKeycode = listeKeycode.indexOf(value);
                const touche = touches[indexKeycode];
                ecran.textContent += touche.innerHTML;
        }
    }
};

/**
 * Sends the calculation expression to the Backend API.
 * Route: POST /api/calculate
 */
const sendCalculation = async (expression) => {
    try {
        // Update UI to show processing state
        ecran.textContent = "Loading...";

        // Note: We use a relative path '/api'. 
        // The Kubernetes Ingress rule defined in the project will route this to the Backend service.
        const response = await fetch('/api/calculate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ calculation: expression })
        });

        if (!response.ok) {
            throw new Error(`Server error: ${response.status}`);
        }

        const data = await response.json();
        
        // If we get a task_id, start polling for the result
        if (data.task_id) {
            pollResult(data.task_id);
        } else {
            throw new Error('No Task ID received');
        }

    } catch (error) {
        console.error('Error initiating calculation:', error);
        ecran.textContent = "Error";
    }
};

/**
 * Polls the API periodically to check if the result is ready in Redis.
 * Route: GET /api/result/<task_id>
 */
const pollResult = (taskId) => {
    const pollInterval = setInterval(async () => {
        try {
            const response = await fetch(`/api/result/${taskId}`);
            
            // Handle cases where the ID might not be found yet (though unlikely if consistent)
            if (response.status === 404) {
                console.warn('Task ID not found yet, retrying...');
                return; 
            }

            const data = await response.json();

            if (data.status === 'Completed') {
                // Success: Display result and stop polling
                ecran.textContent = data.result;
                clearInterval(pollInterval);
            } else if (data.status === 'Pending') {
                // Still processing: Do nothing, wait for next interval
                console.log('Calculation is pending...');
            } else {
                // Handle unexpected statuses
                ecran.textContent = "Error";
                clearInterval(pollInterval);
            }

        } catch (error) {
            console.error('Polling error:', error);
            ecran.textContent = "Err Poll";
            clearInterval(pollInterval);
        }
    }, 1000); // Check every 1 second
};

// Global error handler
window.addEventListener('error', (e) => {
    alert('An unexpected error occurred: ' + e.message);
});