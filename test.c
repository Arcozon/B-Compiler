int	*p() {
	static int a = 2;
	return &a;
}

int main() {
	return *p();
}
