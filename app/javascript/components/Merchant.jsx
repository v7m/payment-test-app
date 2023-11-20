import React, { useContext, useState, useEffect } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";
import { AuthContext } from '../contexts/AuthContext';
import Transactions from './Transactions';

const Merchant = () => {
    const params = useParams();
    const navigate = useNavigate();
    const authContext = useContext(AuthContext);
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
        <div className="vw-100 vh-50 primary-color d-flex align-items-center justify-content-center">
            <div className="jumbotron jumbotron-fluid bg-transparent">
                <div className="container secondary-color text-center">
                    <div>
                        <div className="text-end mb-3 d-inline">
                            <Link to="/" className="btn btn-link">
                                <button type="button" className="btn btn-light">Home</button>
                            </Link>
                        </div>
                        {authContext.isCurrentUserAdmin ? (
                            <div className="text-end mb-3 d-inline">
                                <Link to="/merchants" className="btn btn-link">
                                    <button type="button" className="btn btn-light">Back to merchants</button>
                                </Link>
                            </div>
                        ) : (
                            null
                        )}
                    </div>

                    <div className="row justify-content-md-center mb-3">
                        <div className="col-md-auto">
                            <h2 className="display-2">
                                {merchant.name}
                            </h2>
                            <div className="mb-3">
                                <span className="badge bg-secondary">{merchant.status}</span>
                            </div>
                            <div>
                                {merchant.email}
                            </div>
                        </div>
                    </div>

                    {authContext.isCurrentUserAdmin ? (
                        <div className="row justify-content-md-center">
                            <div className="col-md-auto">
                                <button type="button" className="btn btn-danger" onClick={deleteMerchant}>
                                    Delete Merchant
                                </button>
                            </div>
                        </div>
                    ) : (
                        null
                    )}

                    <Transactions merchant_id={params.id}/>
                </div>
            </div>
        </div>
    );
};

export default Merchant;
