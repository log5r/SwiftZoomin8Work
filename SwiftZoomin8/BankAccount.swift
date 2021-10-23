import Foundation

func bankAccountMain() {
    let account: BankAccount = .init()
    let accountAnother: BankAccount = .init()

    Task {
        await account.deposit(10000)
        await accountAnother.deposit(10)
        print(await account.balance)
        print(await accountAnother.balance)

        try await account.transfer(1200, to: accountAnother)
        print(await account.balance)
        print(await accountAnother.balance)
    }
}

actor BankAccount {
    private(set) var balance: Int = 0

    @discardableResult
    func deposit(_ amount: Int) -> Int {
        balance += amount
        return balance
    }

    func getInterest(with rate: Double) -> Int {
        balance += Int(Double(balance) * rate)
        return balance
    }

    func withdraw(_ amount: Int) throws -> Int {
        let rest = balance - amount
        guard rest > 0 else {
            throw NSError(domain: "おかねがたりません", code: -9)
        }
        balance = rest
        return balance
    }

    func transfer(_ amount: Int, to account: BankAccount) async throws {
        try withdraw(amount)
        await account.deposit(amount)
    }
}
