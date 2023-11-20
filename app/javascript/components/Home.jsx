import React, { useContext } from "react";
import { Link } from "react-router-dom";
import { AuthContext } from '../contexts/AuthContext';

const Home = () => {
    const authContext = useContext(AuthContext);

    return (
        <div className="vw-100 vh-100 primary-color d-flex align-items-center justify-content-center">
            <div className="jumbotron jumbotron-fluid bg-transparent">
                <div className="container secondary-color text-center">
                    <h1 className="display-4">Homepage</h1>
                    <hr className="my-4" />

                    {authContext.currentUser ? (
                        authContext.isCurrentUserAdmin ? (
                            <Link
                                to="/merchants"
                                className="btn btn-lg custom-button"
                                role="button"
                            >
                                Merchants
                            </Link>
                        ) : (
                            <Link
                                to={`/merchants/${authContext.currentUser.id}`}
                                className="btn btn-lg custom-button"
                                role="button"
                            >
                                Merchant
                            </Link>
                        )
                    ) : (
                        <div>Please log in</div>
                    )}
                </div>
            </div>
        </div>
    );
};

export default Home;
