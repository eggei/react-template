import React from 'react'
import ReactDOM from 'react-dom'

// For hot reload feature
import './styles/main.css'

function App() {
  return (
    <div className="wrapper">
      <div className="animated-box" />
      <h1>React Template</h1>
      <div className="color blue" />
      <div className="color skyblue" />
      <div className="color seablue" />
    </div>
  )
}

ReactDOM.render(<App />, document.getElementById('root'))
