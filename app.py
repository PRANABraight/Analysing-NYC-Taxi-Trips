import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from datetime import datetime

# Must be the first Streamlit command
st.set_page_config(
    page_title="NYC Taxi Analytics Dashboard",
    page_icon="🚖",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom CSS
st.markdown("""
    <style>
    .main {
        padding: 0rem 1rem;
    }
    .stTabs [data-baseweb="tab-list"] {
        gap: 2rem;
    }
    .stTabs [data-baseweb="tab"] {
        height: 50px;
        padding-top: 10px;
        padding-bottom: 10px;
    }
    .plot-container {
        border-radius: 5px;
        background: white;
        padding: 10px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .metric-container {
        background: #f8f9fa;
        padding: 15px;
        border-radius: 5px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    </style>
""", unsafe_allow_html=True)

# Add data dictionary tooltips
TOOLTIPS = {
    'payment_type': {
        1: 'Credit card',
        2: 'Cash',
        3: 'No charge',
        4: 'Dispute',
        5: 'Unknown',
        6: 'Voided trip'
    },
    'rate_code': {
        1: 'Standard rate',
        2: 'JFK',
        3: 'Newark',
        4: 'Nassau or Westchester',
        5: 'Negotiated fare',
        6: 'Group ride'
    }
}

# Load data
@st.cache_data
def load_data():
    try:
        df = pd.read_csv("dataset/dataset/test2.csv")
        # Add readable payment types
        df['payment_type_desc'] = df['payment_type'].map(TOOLTIPS['payment_type'])
        # Try multiple date formats
        try:
            df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'], format='%d-%m-%Y %H:%M')
        except:
            try:
                df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'], dayfirst=True)
            except:
                df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'], format='mixed')
        return df
    except Exception as e:
        st.error(f"Error loading data: {str(e)}")
        return None

def main():
    # Header with custom styling
    st.markdown("""
        <h1 style='text-align: center; color: #1f77b4; padding: 1rem 0;'>
            🚖 NYC Taxi Trip Analysis Dashboard
        </h1>
        <p style='text-align: center; color: #666; margin-bottom: 2rem;'>
            Comprehensive analysis of taxi trips, fares, and patterns
        </p>
    """, unsafe_allow_html=True)
    
    # Add information about NYC Taxi Data
    with st.expander("ℹ️ About NYC Taxi Data Collection"):
        st.markdown("""
            <div style='background-color: #f8f9fa; padding: 20px; border-radius: 5px; font-family: sans-serif;'>
            <h3 style='color: #1f77b4; margin-bottom: 15px;'>NYC Taxi Data Collection System</h3>
            <p style='margin-bottom: 20px; line-height: 1.5;color:black;'>The New York City Taxi and Limousine Commission (TLC) 
            collects trip record data through the Taxicab & Livery Passenger Enhancement Programs (TPEP/LPEP). 
            Each taxi trip generates detailed data points including:</p>
            
            <div style='background-color: white; padding: 15px; border-radius: 5px; margin-bottom: 20px;'>
                <h4 style='color: #1f77b4; margin-bottom: 10px; font-size: 1.1em;'>Data Collection Process</h4>
                <ul style='list-style-type: none; padding-left: 0; margin: 0;color:black;'>
                <li style='margin-bottom: 8px; padding-left: 20px; position: relative;'>
                    <span style='position: absolute; left: 0;'>•</span>
                    <strong>TPEP Providers:</strong> Creative Mobile Technologies and VeriFone collect real-time data
                </li>
                <li style='margin-bottom: 8px; padding-left: 20px; position: relative;'>
                    <span style='position: absolute; left: 0;'>•</span>
                    <strong>Automated Recording:</strong> Trip data is captured through taximeters and payment systems
                </li>
                <li style='padding-left: 20px; position: relative;'>
                    <span style='position: absolute; left: 0;'>•</span>
                    <strong>Data Points:</strong> Every trip records time, location, fare, and passenger information
                </li>
                </ul>
            </div>

            <div style='background-color: white; padding: 15px; border-radius: 5px; margin-bottom: 20px;'>
                <h4 style='color: #1f77b4; margin-bottom: 10px; font-size: 1.1em;'>Key Features</h4>
                <ul style='list-style-type: none; padding-left: 0; margin: 0;color:black;'>
                <li style='margin-bottom: 8px; padding-left: 20px; position: relative;'>
                    <span style='position: absolute; left: 0;'>•</span>
                    <strong>Location Data:</strong> Precise GPS-based pickup and dropoff locations
                </li>
                <li style='margin-bottom: 8px; padding-left: 20px; position: relative;'>
                    <span style='position: absolute; left: 0;'>•</span>
                    <strong>Payment Info:</strong> Automatic fare and payment recording
                </li>
                <li style='margin-bottom: 8px; padding-left: 20px; position: relative;'>
                    <span style='position: absolute; left: 0;'>•</span>
                    <strong>Time Data:</strong> Time-stamped journey details
                </li>
                <li style='padding-left: 20px; position: relative;'>
                    <span style='position: absolute; left: 0;'>•</span>
                    <strong>Passenger Data:</strong> Driver-reported passenger counts
                </li>
                </ul>
            </div>

            <div style='font-size: 0.9em; color: #666; margin-top: 20px; padding-top: 15px; border-top: 1px solid #dee2e6;'>
                <strong>Data Source:</strong> NYC Taxi and Limousine Commission (TLC)<br>
                <a href='https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page' 
                   target='_blank' 
                   style='color: #1f77b4; text-decoration: none; margin-top: 5px; display: inline-block;'>
                View TLC Trip Record Data →
                </a>
            </div>
            </div>
        """, unsafe_allow_html=True)

    df = load_data()
    if df is None:
        st.error("Failed to load data. Please check the data format.")
        return

    # Sidebar styling
    st.sidebar.markdown("""
        <div style='text-align: center; padding: 1rem 0;'>
            <h2 style='color: #1f77b4;'>Dashboard Controls</h2>
        </div>
    """, unsafe_allow_html=True)

    try:
        # Create tabs for better organization
        tab1, tab2, tab3 = st.tabs(["📊 Overview", "🔍 Detailed Analysis", "📋 Raw Data"])
        
        with tab1:
            # Date filter in sidebar
            st.sidebar.markdown("### 📅 Date Range Filter")
            date_range = st.sidebar.date_input(
                "Select Date Range",
                [df['tpep_pickup_datetime'].min(), df['tpep_pickup_datetime'].max()]
            )

            # Filter data
            mask = (df['tpep_pickup_datetime'].dt.date >= date_range[0]) & \
                   (df['tpep_pickup_datetime'].dt.date <= date_range[1])
            filtered_df = df[mask]

            # Enhanced metrics with tooltips
            with st.container():
                st.markdown("<div class='metric-container'>", unsafe_allow_html=True)
                col1, col2, col3, col4 = st.columns(4)
                with col1:
                    st.metric("📊 Total Trips", f"{len(filtered_df):,}")
                    st.caption("Number of metered taxi trips")
                with col2:
                    st.metric("💵 Average Fare", f"${filtered_df['fare_amount'].mean():.2f}")
                    st.caption("Time-and-distance fare (excluding extras)")
                with col3:
                    st.metric("📏 Average Distance", f"{filtered_df['trip_distance'].mean():.2f} miles")
                    st.caption("Trip distance reported by taximeter")
                with col4:
                    st.metric("👥 Avg Passengers", f"{filtered_df['passenger_count'].mean():.1f}")
                    st.caption("Driver-reported passenger count")

                # Add data source info
                st.markdown("""
                    <div style='font-size: 0.8em; color: #666;'>
                    Data source: NYC Taxi and Limousine Commission (TLC) - TPEP Provider data
                    </div>
                """, unsafe_allow_html=True)

                # Enhanced charts
                col1, col2 = st.columns(2)
                with col1:
                    st.markdown("<div class='plot-container'>", unsafe_allow_html=True)
                    hourly_trips = filtered_df.groupby(
                        filtered_df['tpep_pickup_datetime'].dt.hour
                    ).size().reset_index(name='count')
                    
                    fig = px.line(hourly_trips, x='tpep_pickup_datetime', y='count',
                                title='Hourly Trip Distribution')
                    fig.update_layout(
                        template='plotly_white',
                        xaxis_title='Hour of Day',
                        yaxis_title='Number of Trips',
                        title_x=0.5
                    )
                    st.plotly_chart(fig, use_container_width=True)
                    st.markdown("</div>", unsafe_allow_html=True)

                with col2:
                    st.markdown("<div class='plot-container'>", unsafe_allow_html=True)
                    fig = px.histogram(filtered_df, x='trip_distance',
                                     nbins=30,
                                     title='Trip Distance Distribution')
                    fig.update_layout(
                        template='plotly_white',
                        xaxis_title='Distance (miles)',
                        yaxis_title='Count',
                        title_x=0.5
                    )
                    st.plotly_chart(fig, use_container_width=True)
                    st.markdown("</div>", unsafe_allow_html=True)

        with tab2:
            st.markdown("<div class='plot-container'>", unsafe_allow_html=True)
            try:
                fig = px.scatter(filtered_df, x='trip_distance', y='fare_amount',
                               trendline="ols",
                               title='Fare Amount vs Distance Analysis')
                fig.update_layout(
                    template='plotly_white',
                    title_x=0.5,
                    xaxis_title='Trip Distance (miles)',
                    yaxis_title='Fare Amount ($)'
                )
            except Exception:
                fig = px.scatter(filtered_df, x='trip_distance', y='fare_amount',
                               title='Fare Amount vs Distance Analysis')
            st.plotly_chart(fig, use_container_width=True)
            st.markdown("</div>", unsafe_allow_html=True)

            # Add payment analysis
            st.markdown("<div class='plot-container'>", unsafe_allow_html=True)
            payment_df = filtered_df.groupby('payment_type_desc').agg({
                'fare_amount': ['mean', 'count'],
                'tip_amount': 'mean'
            }).reset_index()
            
            fig = go.Figure()
            fig.add_trace(go.Bar(
                name='Number of Trips',
                x=payment_df['payment_type_desc'],
                y=payment_df['fare_amount']['count'],
                yaxis='y',
                offsetgroup=1
            ))
            fig.add_trace(go.Bar(
                name='Average Tip',
                x=payment_df['payment_type_desc'],
                y=payment_df['tip_amount']['mean'],
                yaxis='y2',
                offsetgroup=2
            ))
            
            fig.update_layout(
                title='Payment Analysis by Type',
                yaxis=dict(title='Number of Trips'),
                yaxis2=dict(title='Average Tip ($)', overlaying='y', side='right'),
                barmode='group',
                template='plotly_white'
            )
            st.plotly_chart(fig, use_container_width=True)
            
            # Add explanatory text
            st.markdown("""
                <div style='font-size: 0.9em; color: #666; padding: 10px;'>
                <strong>Payment Types:</strong><br>
                • Credit card: Electronic payment<br>
                • Cash: Physical currency<br>
                • No charge: Free rides<br>
                • Dispute: Contested fares<br>
                • Unknown: Unspecified method<br>
                • Voided: Cancelled trips
                </div>
            """, unsafe_allow_html=True)

            # Payment distribution with enhanced styling
            st.markdown("<div class='plot-container'>", unsafe_allow_html=True)
            payment_counts = filtered_df['payment_type'].value_counts()
            fig = px.pie(values=payment_counts.values,
                        names=["Credit card: Electronic payment"," Cash: Physical currency", "No charge: Free rides", "Dispute: Contested fares"],
                        title='Payment Method Distribution')
            fig.update_layout(
                template='plotly_white',
                title_x=0.5
            )
            st.plotly_chart(fig, use_container_width=True)
            st.markdown("</div>", unsafe_allow_html=True)

        with tab3:
            st.markdown("<div class='plot-container'>", unsafe_allow_html=True)
            st.dataframe(
                filtered_df,
                use_container_width=True,
                height=400
            )
            st.markdown("</div>", unsafe_allow_html=True)

    except Exception as e:
        st.error(f"Error in dashboard: {str(e)}")

if __name__ == "__main__":
    main()
