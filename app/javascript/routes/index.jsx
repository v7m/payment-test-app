import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Home from "../components/Home";
import Merchants from "../components/Merchants";
import Merchant from "../components/Merchant";

export default (
    <Router>
        <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/merchants" element={<Merchants />} />
            <Route path="/merchants/:id" element={<Merchant />} />
        </Routes>
    </Router>
);
