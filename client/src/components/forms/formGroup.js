import React from 'react'

export const FormGroup = (props) => {
  const { name, onChange, placeholder, value } = props
  return (
    <div className="form-group">
      <label>{name.capitalize()}</label>
      <input
        className="form-control"
        placeholder={placeholder || name}
        value={value}
        onChange={onChange}
        {...props}
      />
    </div>
  )
}

export default FormGroup