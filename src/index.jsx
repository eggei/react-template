import React from 'react'
import ReactDOM from 'react-dom'

// For hot reload feature
import './styles/main.css'

function App() {
  return (
    <div className="wrapper">
      <div className="animated-circle" />
      <h1 className="text">React Template</h1>
      <p className="text">with Webpack and Docker configuration.</p>
    </div>
  )
}

ReactDOM.render(<App />, document.getElementById('root'))
