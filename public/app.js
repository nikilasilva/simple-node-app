// DOM elements
const tableBody = document.querySelector("#data-table tbody");
const addUserForm = document.querySelector("#add-user-form");

// --- Helper function to add a user row to the table ---
function addUserToTable(user) {
  const tableRow = document.createElement("tr");
  tableRow.innerHTML = `
        <td>${user.id}</td>
        <td>${user.name}</td>
        <td>${user.email}</td>
        <td>${user.phone || "N/A"}</td>
    `;
  tableBody.appendChild(tableRow);
}

// --- Load existing data when the page loads ---
document.addEventListener("DOMContentLoaded", async () => {
  try {
    const response = await fetch("/users"); // Fetch data from our API
    const data = await response.json();

    tableBody.innerHTML = ""; // Clear existing table
    data.forEach(addUserToTable); // Add each user to the table
  } catch (error) {
    console.error("Error fetching data:", error);
  }
});

// --- Listen for the new user form submission ---
addUserForm.addEventListener("submit", async (e) => {
  e.preventDefault(); // Prevent the form from reloading the page

  // Get data from the form
  const name = e.target.name.value;
  const email = e.target.email.value;
  const phone = e.target.phone.value;

  try {
    const response = await fetch("/users", {
      // Send data to our API
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ name, email, phone }),
    });

    if (!response.ok) {
      throw new Error("Failed to add user.");
    }

    const newUser = await response.json();

    // Add the new user to the table
    addUserToTable(newUser);

    // Clear the form fields
    e.target.reset();
  } catch (error) {
    console.error("Error adding user:", error);
  }
});
