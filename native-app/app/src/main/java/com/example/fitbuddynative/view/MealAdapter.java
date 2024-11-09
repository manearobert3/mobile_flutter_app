package com.example.fitbuddynative.view;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageButton;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.fitbuddynative.R;
import com.example.fitbuddynative.model.Meal;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class MealAdapter  extends RecyclerView.Adapter<MealAdapter.MealViewHolder> {

    private List<Meal> mealList;
    private final OnItemClickListener listener;
    public interface OnItemClickListener {
        void onItemClick(int position);
        void onEditClick(int position);
        void onDeleteClick(int position);
    }

    public MealAdapter(List<Meal> mealList, OnItemClickListener listener) {
        this.mealList = mealList != null ? new ArrayList<>(mealList) : new ArrayList<>();
        this.listener = listener;
    }

    public void setMeals(List<Meal> meals){
        this.mealList = meals;
        notifyDataSetChanged();
    }


    public void removeMeal(int position) {
        mealList.remove(position);
        notifyItemRemoved(position);
    }

    @NonNull
    @Override
    public MealAdapter.MealViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.meal_item, parent, false);
        return new MealViewHolder(v, listener);
    }

    @Override
    public void onBindViewHolder(@NonNull MealAdapter.MealViewHolder holder, int position) {
        Meal currentMeal = mealList.get(position);
        holder.textViewMealName.setText(currentMeal.getName());
        holder.textViewType.setText(currentMeal.getMeal_type());
        holder.textViewCalories.setText(String.valueOf(currentMeal.getTotal_calories()));
        LocalDate dateTimeLogged = currentMeal.getDate_logged();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        holder.textViewDateLogged.setText(dateTimeLogged.format(formatter));
    }

    @Override
    public int getItemCount() {
        return (mealList != null) ? mealList.size() : 0;
    }

    public static class MealViewHolder extends RecyclerView.ViewHolder{
        public TextView textViewMealName;
        public TextView textViewType;
        public TextView textViewCalories;
        public TextView textViewDateLogged;
        public ImageButton buttonEdit;
        public ImageButton buttonDelete;
        public MealViewHolder(@NonNull View itemView, final OnItemClickListener listener) {
            super(itemView);
            textViewMealName = itemView.findViewById(R.id.textViewMealName);
            textViewType = itemView.findViewById(R.id.textViewMealType);
            textViewCalories = itemView.findViewById(R.id.textViewCalories);
            textViewDateLogged = itemView.findViewById(R.id.textViewDateLogged);
            buttonEdit = itemView.findViewById(R.id.button_edit);
            buttonDelete = itemView.findViewById(R.id.button_delete);

            itemView.setOnClickListener(v -> {
                if(listener != null){
                    int position = getAdapterPosition();
                    if(position != RecyclerView.NO_POSITION){
                        listener.onItemClick(position);
                    }
                }
            });
            buttonEdit.setOnClickListener(v -> {
                if (listener != null) {
                    int position = getAdapterPosition();
                    if (position != RecyclerView.NO_POSITION) {
                        listener.onEditClick(position);
                    }
                }
            });
            buttonDelete.setOnClickListener(v -> {
                if (listener != null) {
                    int position = getAdapterPosition();
                    if (position != RecyclerView.NO_POSITION) {
                        listener.onDeleteClick(position);
                    }
                }
            });
        }
    }
}
