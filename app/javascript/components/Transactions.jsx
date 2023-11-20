import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";

const Transactions = ({ merchant_id }) => {
    const navigate = useNavigate();
    const [transactions, setTransactions] = useState([]);

    useEffect(() => {
        const url = `/api/v1/merchants/${merchant_id}/transactions`; 
        fetch(url)
            .then((response) => {
                if (response.ok) { return response.json(); }
                throw new Error("Network response was not ok.");
            })
            .then((response) => setTransactions(response))
            .catch(() => navigate("/"));
    }, []);

    const allTransactions = transactions.map((transaction, index) => (
        <table className="table">
            <tbody>
                { 
                    transactions.map((transaction, index) => (
                        <tr key={index + 1}>
                            <th scope="row">{index + 1}</th>
                            <td>{transaction.id}</td>
                            <td>{transaction.email}</td>
                            <td>@{transaction.status}</td>
                        </tr>
                    )) 
                }
            </tbody>
        </table> 
    ));

    return (
        <>
            <div className="py-5">
                <main className="container">
                            {transactions.length > 0 ? (
                                <div>
                                    <div>
                                        <h4>Transactions</h4>
                                    </div>   
                                    <table className="table">
                                        <thead>
                                            <tr>
                                            <th scope="col">#</th>
                                            <th scope="col">ID</th>
                                            <th scope="col">Customer email</th>
                                            <th scope="col">Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            { 
                                                transactions.map((transaction, index) => (
                                                    <tr key={index + 1}>
                                                        <th scope="row">{index + 1}</th>
                                                        <td>{transaction.id}</td>
                                                        <td>{transaction.customer_email}</td>
                                                        <td>{transaction.status}</td>
                                                    </tr>
                                                )) 
                                            }
                                        </tbody>
                                    </table> 
                                </div>
                            ):(
                                <div>
                                    <h4>No transaction yet.</h4>
                                </div>
                            )}
                </main>
            </div>
        </>
    );
};

export default Transactions;