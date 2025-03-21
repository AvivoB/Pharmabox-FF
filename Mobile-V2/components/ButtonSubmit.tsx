import React from 'react';
import { Button } from './Button';
import { useForm } from './Form';

interface ButtonSubmitProps {
  text: string;
  classNameProps?: string; 
}

export const ButtonSubmit = ({ text, classNameProps }: ButtonSubmitProps) => {
  const { isValid, handleSubmit } = useForm();

  return (
    <Button 
      onPress={handleSubmit} 
      classNameProps={classNameProps}
      text={text} 
    />
  );
};
