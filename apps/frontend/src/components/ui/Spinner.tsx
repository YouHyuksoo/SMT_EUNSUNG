"use client";

import { Loader2 } from "lucide-react";

interface SpinnerProps {
  size?: "sm" | "md" | "lg";
  className?: string;
}

const sizeClass = {
  sm: "h-4 w-4",
  md: "h-6 w-6",
  lg: "h-8 w-8",
};

export default function Spinner({ size = "md", className = "" }: SpinnerProps) {
  return (
    <Loader2
      className={`${sizeClass[size]} animate-spin text-primary ${className}`}
      aria-label="loading"
    />
  );
}
