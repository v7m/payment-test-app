import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App";
import { AuthProvider } from '../contexts/AuthContext';

document.addEventListener("turbo:load", () => {
    const root = createRoot(
        document.body.appendChild(document.createElement("div"))
    );
    root.render(
        <React.StrictMode>
            <AuthProvider>
                <App />
            </AuthProvider>
        </React.StrictMode>
    );
});
