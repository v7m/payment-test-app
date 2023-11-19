import React, { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";

const Merchants = () => {
    const navigate = useNavigate();
    const [merchants, setMerchants] = useState([]);

    useEffect(() => {
        const url = "/api/v1/merchants";
        fetch(url)
            .then((response) => {
                if (response.ok) { return response.json(); }
                throw new Error("Network response was not ok.");
            })
            .then((response) => setMerchants(response))
            .catch(() => navigate("/"));
    }, []);

    const allMerchants = merchants.map((merchant, index) => (
        <div key={index} className="col-md-6 col-lg-4">
            <div className="card mb-4">
                <Link to={`/merchants/${merchant.id}`} className="btn custom-button">
                    <div className="card-body">
                        <h5 className="card-title">{merchant.name}</h5>
                    </div>
                </Link>
            </div>
        </div>
    ));

    const noMerchant = (
        <div className="vw-100 vh-50 d-flex align-items-center justify-content-center">
            <h4>
                No merchants yet.
            </h4>
        </div>
    );

    return (
        <>
            <div className="py-5">
                <main className="container">
                    <div className="text-end mb-3">
                        <Link to="/" className="btn btn-link">
                            Home
                        </Link>
                    </div>
                    <div className="row">
                        {merchants.length > 0 ? allMerchants : noMerchant}
                    </div>
                </main>
            </div>
        </>
    );
};

export default Merchants;