import React, { useState, useEffect } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";

const Merchant = () => {
    const params = useParams();
    const navigate = useNavigate();
    const [merchant, setMerchant] = useState({ ingredients: "" });

    useEffect(() => {
        const url = `/api/v1/merchants/${params.id}`;
        fetch(url)
            .then((response) => {
                if (response.ok) { return response.json(); }
                throw new Error("Network response was not ok.");
            })
            .then((response) => setMerchant(response))
            .catch(() => navigate("/merchants"));
    }, [params.id]);
    
    const deleteMerchant = () => {
        const url = `/api/v1/merchants/${params.id}`;
        const token = document.querySelector('meta[name="csrf-token"]').content;

        fetch(url, {
            method: "DELETE",
            headers: {
                "X-CSRF-Token": token,
                "Content-Type": "application/json",
            },
        })
        .then((response) => {
            if (response.ok) { return response.json(); }
            throw new Error("Network response was not ok.");
        })
        .then(() => navigate("/merchants"))
        .catch((error) => console.log(error.message));
    };

    return (
        <div className="vw-100 vh-100 primary-color d-flex align-items-center justify-content-center">
            <div className="jumbotron jumbotron-fluid bg-transparent">
                <div className="container secondary-color text-center">
                    <div>
                        <div className="text-end mb-3 d-inline">
                            <Link to="/" className="btn btn-link">
                                Home
                            </Link>
                        </div>
                        <div className="text-end mb-3 d-inline">
                            <Link to="/merchants" className="btn btn-link">
                                Back to merchants
                            </Link>
                        </div>
                    </div>

                    <div className="row justify-content-md-center mb-3">
                        <div className="col-md-auto">
                            <h2 className="display-2">
                                {merchant.name}
                            </h2>
                            <h6 className="mb-3 display-6">
                                <span class="badge bg-secondary">{merchant.status}</span>
                            </h6>
                            <h6 className="display-6">
                                {merchant.email}
                            </h6>
                        </div>
                    </div>

                    <div className="row justify-content-md-center">
                        <div className="col-md-auto">
                            <button type="button" className="btn btn-danger" onClick={deleteMerchant}>
                                Delete Merchant
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Merchant;
