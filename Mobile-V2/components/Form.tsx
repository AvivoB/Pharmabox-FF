import React, { createContext, useContext, useState } from 'react';
import { View } from 'react-native';

type FormValues = Record<string, string>;

interface FormContextType {
  values: FormValues;
  errors: Record<string, string>;
  setFieldValue: (name: string, value: string) => void;
  setFieldError: (name: string, error: string) => void;
  isValid: boolean;
  handleSubmit: () => void;
}

const FormContext = createContext<FormContextType>({
  values: {},
  errors: {},
  setFieldValue: () => {},
  setFieldError: () => {},
  isValid: true,
  handleSubmit: () => {},
});

export const useForm = () => useContext(FormContext);

interface FormProps {
  children: React.ReactNode;
  onSubmit: (values: FormValues) => void;
  initialValues?: FormValues;
}

export const Form = ({ children, onSubmit, initialValues = {} }: FormProps) => {
  const [values, setValues] = useState<FormValues>(initialValues);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [isValid, setIsValid] = useState(false);

  const setFieldValue = (name: string, value: string) => {
    setValues(prev => ({ ...prev, [name]: value }));
  };

  const setFieldError = (name: string, error: string) => {
    setErrors(prev => ({ ...prev, [name]: error }));
    setIsValid(Object.keys(errors).length === 0);
  };

  const handleSubmit = () => {
    console.log('handleSubmit');
    onSubmit(values);
    // TODO : Validate form
    if (isValid) {
    }
  };

  return (
    <FormContext.Provider value={{ 
        values, 
        errors, 
        setFieldValue, 
        setFieldError,
        isValid,
        handleSubmit
    }}>
      <View>
        {children}
      </View>
    </FormContext.Provider>
  );
};
