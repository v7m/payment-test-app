import React, { createContext, useState, useEffect } from 'react';

const AuthContext = createContext();

const AuthProvider = ({ children }) => {
    const [currentUser, setCurrentUser] = useState({});

    useEffect(() => {
        fetch("/api/v1/current_user")
            .then((response) => {
                if (response.ok) { return response.json(); }
                throw new Error("Network response was not ok.");
            })
            .then((response) => {debugger; setCurrentUser(response)})
            .catch((error) => console.error("Error fetching user data: ", error));
    }, []);

    const isCurrentUserAdmin = () => {
        return currentUser && currentUser.role == "admin";
    }

    return (
        <AuthContext.Provider 
            value={{ 
                currentUser: currentUser,
                isCurrentUserAdmin: isCurrentUserAdmin()
            }}
        >
            {children}
        </AuthContext.Provider>
    );
};

export { AuthProvider, AuthContext };
