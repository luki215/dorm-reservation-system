from locust import HttpLocust, TaskSet, task, events
import logging, sys, random

USER_CREDENTIALS = [
    (f"zamluvy.kolejeuk+{i}@gmail.com", "123456") for i in range(1, 1000)
]

BUILDINGS = ["A", "B"]
FLOORS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
RESERVATION_ROOMS=range(1086, 2557)

class UserBehavior(TaskSet):
    email = "NOT_FOUND"
    password = "NOT_FOUND"

    def on_start(self):
        if len(USER_CREDENTIALS) > 0:
            self.email, self.password = USER_CREDENTIALS.pop()
            self.login()

    def on_stop(self):
        """ on_stop is called when the TaskSet is stopping """
        self.logout()
    
    def login(self):
        self.client.post("/sign_in", data={
            "user[email]": "zamluvy.kolejeuk+1@gmail.com", 'user[password]': "123456"
        })

        logging.info('Login with %s email and %s password', self.email, self.password)

    def logout(self):
        self.client.post("/sign_out", {"_method": "delete"})

    # @task(1)
    # def index(self):
    #     self.client.get("/")
    

    # @task(2)
    # def reservations_root(self):
    #     self.client.get(f"/reservations")

    # @task(4)
    # def reservations_building(self):
    #     self.client.get(f"/reservations?building={random.choice(BUILDINGS)}")

    # @task(6)
    # def reservations_floor(self):
    #     self.client.get(f"/reservations?building={random.choice(BUILDINGS)}&floor={random.choice(FLOORS)}")

    @task(1)
    def make_reservation(self):
        print(f"/reservations/{random.choice(RESERVATION_ROOMS)}/reservations/create")
        self.client.post(f"/reservations/{random.choice(RESERVATION_ROOMS)}/reservations/create", data={})
        

class WebsiteUser(HttpLocust):
    host = "https://listopad.zamluvy.koleje.cuni.cz"
    task_set = UserBehavior
    min_wait = 5000
    max_wait = 9000


def on_failure(request_type, name, response_time, exception, **kwargs):
    print(exception.request.url)
    print(exception.response.status_code)
    print(exception.response.content)

events.request_failure += on_failure
